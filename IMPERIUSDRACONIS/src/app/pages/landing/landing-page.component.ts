import { CommonModule } from '@angular/common';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import {
  ChangeDetectionStrategy,
  Component,
  DestroyRef,
  inject,
  signal
} from '@angular/core';
import { RouterLink } from '@angular/router';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import {
  LucideArrowRight,
  LucideDynamicIcon,
  LucideExternalLink,
  LucideLogIn,
  LucideSparkles,
  LucideTrophy,
  provideLucideIcons
} from '@lucide/angular';
import { LandingPage } from '../../core/models/landing.models';
import { LandingService } from '../../core/services/landing.service';
import { RuntimeConfigService } from '../../core/services/runtime-config.service';
import { resolveProfileAvatarUrl } from '../../core/constants/profile.constants';

@Component({
  selector: 'app-landing-page',
  imports: [CommonModule, RouterLink, LucideDynamicIcon],
  providers: [
    provideLucideIcons(
      LucideArrowRight,
      LucideExternalLink,
      LucideLogIn,
      LucideSparkles,
      LucideTrophy
    )
  ],
  templateUrl: './landing-page.component.html',
  styleUrl: './landing-page.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class LandingPageComponent {
  private readonly destroyRef = inject(DestroyRef);
  private readonly landingService = inject(LandingService);
  private readonly runtimeConfig = inject(RuntimeConfigService);
  private readonly sanitizer = inject(DomSanitizer);

  readonly data = signal<LandingPage | null>(null);
  readonly loading = signal(true);
  readonly errorMessage = signal('');

  constructor() {
    this.load();
  }

  assetUrl(path: string): string {
    return this.runtimeConfig.resolveApiAssetUrl(path);
  }

  profileUrl(path: string): string {
    return resolveProfileAvatarUrl(path, this.runtimeConfig);
  }

  houseShieldUrl(houseName: string): string {
    const normalized = houseName.trim().toLowerCase();
    if (normalized.includes('gryffindor')) return '/theme-assets/gryffindor-shield.webp';
    if (normalized.includes('slytherin')) return '/theme-assets/slytherin-shield.webp';
    if (normalized.includes('ravenclaw')) return '/theme-assets/ravenclaw-shield.webp';
    if (normalized.includes('hufflepuff')) return '/theme-assets/hufflepuff-shield.webp';
    return '/theme-assets/imperius-logo.webp';
  }

  safeExternalUrl(url: string): string {
    return /^https?:\/\//i.test(url) ? url : '#';
  }

  embedUrl(url: string): SafeResourceUrl {
    return this.sanitizer.bypassSecurityTrustResourceUrl(url);
  }

  private load(): void {
    this.landingService
      .getPublic()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (data) => {
          this.data.set(data);
          this.loading.set(false);
        },
        error: () => {
          this.errorMessage.set('No fue posible cargar las novedades en este momento.');
          this.loading.set(false);
        }
      });
  }
}
