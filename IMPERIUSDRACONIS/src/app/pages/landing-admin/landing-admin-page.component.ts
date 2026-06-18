import { CommonModule } from '@angular/common';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import {
  ChangeDetectionStrategy,
  Component,
  DestroyRef,
  inject,
  signal
} from '@angular/core';
import { FormsModule } from '@angular/forms';
import {
  LucideEye,
  LucideDynamicIcon,
  LucideImagePlus,
  LucideSave,
  LucideTrash2,
  provideLucideIcons
} from '@lucide/angular';
import { finalize } from 'rxjs';
import {
  LandingAdmin,
  LandingContentItem,
  SaveLandingContent
} from '../../core/models/landing.models';
import { LandingService } from '../../core/services/landing.service';
import { RuntimeConfigService } from '../../core/services/runtime-config.service';
import { readHttpErrorMessage } from '../../core/utils/http-error.utils';

interface EditableLandingItem extends LandingContentItem {
  imagenFile: File | null;
  enlaceOEmbed: string;
}

type AdminSection = 'portada' | 'plata' | 'oro' | 'redes' | 'gaceta' | 'escapes';

@Component({
  selector: 'app-landing-admin-page',
  imports: [CommonModule, FormsModule, LucideDynamicIcon],
  providers: [
    provideLucideIcons(LucideEye, LucideImagePlus, LucideSave, LucideTrash2)
  ],
  templateUrl: './landing-admin-page.component.html',
  styleUrl: './landing-admin-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LandingAdminPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly landingService = inject(LandingService);
  private readonly runtimeConfig = inject(RuntimeConfigService);

  readonly data = signal<LandingAdmin | null>(null);
  readonly loading = signal(true);
  readonly savingKey = signal('');
  readonly errorMessage = signal('');
  readonly successMessage = signal('');
  readonly activeSection = signal<AdminSection>('portada');

  tituloPortada = '';
  subtituloPortada = '';
  idCasaGanadora: number | null = null;
  tituloCopa = '';
  descripcionCopa = '';
  silver: EditableLandingItem[] = [];
  gold: EditableLandingItem | null = null;
  instagram: EditableLandingItem[] = [];
  tiktok: EditableLandingItem[] = [];
  gazette: EditableLandingItem[] = [];
  escapes: EditableLandingItem[] = [];

  constructor() {
    this.load();
  }

  setSection(section: AdminSection): void {
    this.activeSection.set(section);
    this.clearMessages();
  }

  saveConfiguration(): void {
    this.savingKey.set('config');
    this.clearMessages();
    this.landingService
      .saveConfiguration({
        tituloPortada: this.tituloPortada.trim(),
        subtituloPortada: this.subtituloPortada.trim() || null,
        idCasaGanadora: this.idCasaGanadora,
        tituloCopa: this.tituloCopa.trim() || null,
        descripcionCopa: this.descripcionCopa.trim() || null
      })
      .pipe(
        finalize(() => this.savingKey.set('')),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => this.successMessage.set('Portada y copa actualizadas correctamente.'),
        error: (error) =>
          this.errorMessage.set(readHttpErrorMessage(error, 'No se pudo guardar la configuración.'))
      });
  }

  saveItem(item: EditableLandingItem): void {
    if (item.tipo === 'PLATA') {
      item.activo = true;
    }

    const key = `${item.tipo}-${item.posicion}`;
    this.savingKey.set(key);
    this.clearMessages();
    this.landingService
      .saveContent(item.tipo.toLowerCase(), item.posicion, this.toPayload(item))
      .pipe(
        finalize(() => this.savingKey.set('')),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: (saved) => {
          this.replaceItem(saved);
          this.successMessage.set('Contenido guardado correctamente.');
        },
        error: (error) =>
          this.errorMessage.set(readHttpErrorMessage(error, 'No se pudo guardar el contenido.'))
      });
  }

  addGazetteItem(): void {
    const position = Math.max(0, ...this.gazette.map((item) => item.posicion)) + 1;
    if (position > 12) {
      this.errorMessage.set('La gaceta admite hasta 12 imágenes.');
      return;
    }

    this.gazette = [
      ...this.gazette,
      this.editable({
        idContenido: 0,
        tipo: 'GACETA',
        posicion: position,
        titulo: '',
        descripcion: '',
        meta: '',
        imagenUrl: '',
        enlaceUrl: '',
        activo: true
      })
    ];
  }

  deleteGazetteItem(item: EditableLandingItem): void {
    if (item.idContenido === 0) {
      this.gazette = this.gazette.filter((current) => current !== item);
      return;
    }

    const key = `delete-GACETA-${item.posicion}`;
    this.savingKey.set(key);
    this.clearMessages();
    this.landingService
      .deleteGazette(item.posicion)
      .pipe(
        finalize(() => this.savingKey.set('')),
        takeUntilDestroyed(this.destroyRef)
      )
      .subscribe({
        next: () => {
          this.gazette = this.gazette.filter(
            (current) => current.posicion !== item.posicion
          );
          this.successMessage.set('Imagen de gaceta eliminada.');
        },
        error: (error) =>
          this.errorMessage.set(readHttpErrorMessage(error, 'No se pudo eliminar la imagen.'))
      });
  }

  selectFile(item: EditableLandingItem, event: Event): void {
    const input = event.target as HTMLInputElement;
    item.imagenFile = input.files?.[0] ?? null;
  }

  imageUrl(item: EditableLandingItem): string {
    return item.imagenUrl ? this.runtimeConfig.resolveApiAssetUrl(item.imagenUrl) : '';
  }

  private load(): void {
    this.landingService
      .getAdmin()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (data) => {
          this.data.set(data);
          this.tituloPortada = data.configuracion.tituloPortada;
          this.subtituloPortada = data.configuracion.subtituloPortada;
          this.idCasaGanadora = data.configuracion.idCasaGanadora;
          this.tituloCopa = data.configuracion.tituloCopa;
          this.descripcionCopa = data.configuracion.descripcionCopa;
          this.silver = data.dragonesPlata.map((item) => this.editable(item));
          this.gold = data.dragonOro ? this.editable(data.dragonOro) : null;
          this.instagram = data.instagram.map((item) => this.editable(item));
          this.tiktok = data.tiktok.map((item) => this.editable(item));
          this.gazette = data.gaceta.map((item) => this.editable(item));
          this.escapes = data.escapeRooms.map((item) => this.editable(item));
          this.loading.set(false);
        },
        error: (error) => {
          this.errorMessage.set(
            readHttpErrorMessage(error, 'No se pudo cargar la administración de la portada.')
          );
          this.loading.set(false);
        }
      });
  }

  private editable(item: LandingContentItem): EditableLandingItem {
    return {
      ...item,
      imagenFile: null,
      enlaceOEmbed: item.enlaceUrl
    };
  }

  private toPayload(item: EditableLandingItem): SaveLandingContent {
    return {
      titulo: item.titulo,
      descripcion: item.descripcion,
      meta: item.meta,
      imagenUrlActual: item.imagenUrl,
      enlaceOEmbed: item.enlaceOEmbed,
      activo: item.activo,
      imagenFile: item.imagenFile
    };
  }

  private replaceItem(saved: LandingContentItem): void {
    const replace = (items: EditableLandingItem[]) =>
      items.map((item) =>
        item.tipo === saved.tipo && item.posicion === saved.posicion
          ? this.editable(saved)
          : item
      );

    if (saved.tipo === 'PLATA') this.silver = replace(this.silver);
    if (saved.tipo === 'ORO') this.gold = this.editable(saved);
    if (saved.tipo === 'INSTAGRAM') this.instagram = replace(this.instagram);
    if (saved.tipo === 'TIKTOK') this.tiktok = replace(this.tiktok);
    if (saved.tipo === 'GACETA') this.gazette = replace(this.gazette);
    if (saved.tipo === 'ESCAPE') this.escapes = replace(this.escapes);
  }

  private clearMessages(): void {
    this.errorMessage.set('');
    this.successMessage.set('');
  }
}
