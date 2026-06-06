import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ChangeDetectionStrategy, Component, DestroyRef, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { finalize, switchMap } from 'rxjs';
import {
  DEFAULT_PROFILE_AVATAR,
  PROFILE_AVATARS,
  PROFILE_COUNTRIES,
  ProfileAvatarOption,
  ProfileCountryOption,
  getSuggestedTimezones,
  resolveProfileAvatarUrl
} from '../../core/constants/profile.constants';
import {
  ChangeMyPasswordRequest,
  PerfilDetail,
  UpdateMyProfileRequest
} from '../../core/models/perfil.models';
import { AuthService } from '../../core/services/auth.service';
import { PerfilService } from '../../core/services/perfil.service';

interface PerfilFormModel {
  telefono: string;
  correoElectronico: string;
  cumpleanos: string;
  pais: string;
  prefijoPais: string;
  zonaHoraria: string;
  fotoPerfil: string;
}

@Component({
  selector: 'app-perfil-page',
  imports: [CommonModule, FormsModule],
  templateUrl: './perfil-page.component.html',
  styleUrl: './perfil-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class PerfilPageComponent {
  private readonly destroyRef = inject(DestroyRef);

  readonly auth = inject(AuthService);
  readonly perfilService = inject(PerfilService);

  readonly perfil = signal<PerfilDetail | null>(null);
  readonly loading = signal(true);
  readonly saving = signal(false);
  readonly changingPassword = signal(false);
  readonly uploadingAvatar = signal(false);
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly activeModal = signal<'info' | 'avatar' | 'password' | null>(null);

  readonly countries: readonly ProfileCountryOption[] = PROFILE_COUNTRIES;
  readonly avatarOptions: readonly ProfileAvatarOption[] = PROFILE_AVATARS;

  availableTimezones = getSuggestedTimezones();
  form: PerfilFormModel = this.createEmptyForm();

  contrasenaActual = '';
  nuevaContrasena = '';
  confirmarContrasena = '';

  constructor() {
    this.loadProfile();
  }

  loadProfile(): void {
    this.loading.set(true);
    this.errorMessage.set('');

    this.perfilService
      .getProfile()
      .pipe(
        finalize(() => this.loading.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (perfil) => {
          this.perfil.set(perfil);
          this.form = this.mapProfileToForm(perfil);
          this.includeTimezone(perfil.zonaHoraria);
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo cargar tu perfil.'));
        }
      });
  }

  openInfoModal(): void {
    const current = this.perfil();
    if (current) {
      this.form = this.mapProfileToForm(current);
      this.includeTimezone(current.zonaHoraria);
    }

    this.clearMessages();
    this.activeModal.set('info');
  }

  openAvatarModal(): void {
    this.clearMessages();
    this.activeModal.set('avatar');
  }

  openPasswordModal(): void {
    this.contrasenaActual = '';
    this.nuevaContrasena = '';
    this.confirmarContrasena = '';
    this.clearMessages();
    this.activeModal.set('password');
  }

  closeModal(): void {
    this.activeModal.set(null);
  }

  saveProfile(): void {
    const payload = this.buildProfilePayload();
    if (!payload) {
      return;
    }

    this.clearMessages();
    this.saving.set(true);

    this.perfilService
      .updateProfile(payload)
      .pipe(
        switchMap(() => this.auth.hydrateSession()),
        switchMap(() => this.perfilService.getProfile()),
        finalize(() => this.saving.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (perfil) => {
          this.perfil.set(perfil);
          this.form = this.mapProfileToForm(perfil);
          this.includeTimezone(perfil.zonaHoraria);
          this.successMessage.set('Perfil actualizado correctamente.');
          this.closeModal();
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo actualizar tu perfil.'));
        }
      });
  }

  changePassword(): void {
    const contrasenaActual = this.contrasenaActual.trim();
    const nuevaContrasena = this.nuevaContrasena.trim();
    const confirmacion = this.confirmarContrasena.trim();

    if (!contrasenaActual) {
      this.errorMessage.set('Debes ingresar tu contraseña actual.');
      return;
    }

    if (nuevaContrasena.length < 6) {
      this.errorMessage.set('La nueva contraseña debe tener al menos 6 caracteres.');
      return;
    }

    if (nuevaContrasena !== confirmacion) {
      this.errorMessage.set('La confirmación de la contraseña no coincide.');
      return;
    }

    const payload: ChangeMyPasswordRequest = {
      contrasenaActual,
      nuevaContrasena
    };

    this.clearMessages();
    this.changingPassword.set(true);

    this.perfilService
      .changePassword(payload)
      .pipe(
        finalize(() => this.changingPassword.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.contrasenaActual = '';
          this.nuevaContrasena = '';
          this.confirmarContrasena = '';
          this.successMessage.set('Contraseña actualizada correctamente.');
          this.closeModal();
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo actualizar la contraseña.'));
        }
      });
  }

  applyCountryPrefix(): void {
    const country = this.countries.find((current) => current.nombre === this.form.pais);
    if (country?.prefijo) {
      this.form = {
        ...this.form,
        prefijoPais: country.prefijo
      };
    }
  }

  selectAvatar(avatar: ProfileAvatarOption): void {
    this.form = {
      ...this.form,
      fotoPerfil: avatar.value
    };

    this.saveProfile();
  }

  resetAvatar(): void {
    this.form = {
      ...this.form,
      fotoPerfil: DEFAULT_PROFILE_AVATAR
    };

    this.saveProfile();
  }

  uploadCustomAvatar(event: Event): void {
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0];
    input.value = '';

    if (!file) {
      return;
    }

    if (!file.type.startsWith('image/')) {
      this.errorMessage.set('Selecciona una imagen valida para tu perfil.');
      return;
    }

    this.clearMessages();
    this.uploadingAvatar.set(true);

    this.perfilService
      .uploadProfileImage(file)
      .pipe(
        finalize(() => this.uploadingAvatar.set(false)),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (response) => {
          this.form = {
            ...this.form,
            fotoPerfil: response.fotoPerfil
          };
          this.saveProfile();
        },
        error: (error) => {
          this.errorMessage.set(this.readErrorMessage(error, 'No se pudo subir la imagen de perfil.'));
        }
      });
  }

  avatarUrl(path?: string | null): string {
    return resolveProfileAvatarUrl(path ?? this.form.fotoPerfil);
  }

  completionPercent(): number {
    const fields = [
      this.form.pais,
      this.form.prefijoPais,
      this.form.telefono,
      this.form.correoElectronico,
      this.form.cumpleanos,
      this.form.zonaHoraria
    ];
    const completed = fields.filter((value) => value.trim().length > 0).length;

    return Math.round((completed / fields.length) * 100);
  }

  isSelectedAvatar(avatar: ProfileAvatarOption): boolean {
    return avatar.value === (this.form.fotoPerfil || DEFAULT_PROFILE_AVATAR);
  }

  private buildProfilePayload(): UpdateMyProfileRequest | null {
    const correo = this.form.correoElectronico.trim();
    if (correo && !correo.includes('@')) {
      this.errorMessage.set('El correo electrónico no tiene un formato válido.');
      return null;
    }

    return {
      telefono: this.normalizeText(this.form.telefono),
      correoElectronico: this.normalizeText(correo),
      cumpleanos: this.form.cumpleanos || null,
      pais: this.normalizeText(this.form.pais),
      prefijoPais: this.normalizeText(this.form.prefijoPais),
      zonaHoraria: this.normalizeText(this.form.zonaHoraria),
      fotoPerfil: this.normalizeText(this.form.fotoPerfil) ?? DEFAULT_PROFILE_AVATAR
    };
  }

  private mapProfileToForm(perfil: PerfilDetail): PerfilFormModel {
    return {
      telefono: perfil.telefono,
      correoElectronico: perfil.correoElectronico,
      cumpleanos: this.toDateInputValue(perfil.cumpleanos),
      pais: perfil.pais,
      prefijoPais: perfil.prefijoPais,
      zonaHoraria: perfil.zonaHoraria,
      fotoPerfil: perfil.fotoPerfil || DEFAULT_PROFILE_AVATAR
    };
  }

  private includeTimezone(value: string | null | undefined): void {
    const timezone = value?.trim();
    if (!timezone || this.availableTimezones.includes(timezone)) {
      return;
    }

    this.availableTimezones = [...this.availableTimezones, timezone].sort((left, right) =>
      left.localeCompare(right)
    );
  }

  private createEmptyForm(): PerfilFormModel {
    return {
      telefono: '',
      correoElectronico: '',
      cumpleanos: '',
      pais: '',
      prefijoPais: '',
      zonaHoraria: '',
      fotoPerfil: DEFAULT_PROFILE_AVATAR
    };
  }

  private normalizeText(value: string): string | null {
    const trimmed = value.trim();
    return trimmed ? trimmed : null;
  }

  private toDateInputValue(value: string | null): string {
    if (!value) {
      return '';
    }

    return value.split('T')[0] ?? '';
  }

  private clearMessages(): void {
    this.errorMessage.set('');
    this.successMessage.set('');
  }

  private readErrorMessage(error: unknown, fallback: string): string {
    if (error instanceof HttpErrorResponse) {
      if (typeof error.error === 'string' && error.error.trim()) {
        return error.error;
      }

      if (error.error?.message) {
        return error.error.message as string;
      }
    }

    return fallback;
  }
}
