import { Directive, HostListener, Input } from '@angular/core';

const DEFAULT_IMAGE_PLACEHOLDER = `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(
  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 220" fill="none"><rect width="320" height="220" rx="24" fill="#0f172a"/><rect x="24" y="24" width="272" height="172" rx="18" fill="#111827" stroke="#334155" stroke-width="2"/><circle cx="121" cy="84" r="18" fill="#475569"/><path d="M86 152l42-48 31 35 38-49 37 62H86z" fill="#334155"/><text x="160" y="192" fill="#cbd5e1" font-family="Verdana, Arial, sans-serif" font-size="20" text-anchor="middle">Sin imagen</text></svg>'
)}`;

@Directive({
  selector: 'img[appImageFallback]',
  standalone: true
})
export class ImageFallbackDirective {
  @Input() appImageFallback = DEFAULT_IMAGE_PLACEHOLDER;

  @HostListener('error', ['$event.target'])
  onError(target: EventTarget | null): void {
    const image = target as HTMLImageElement | null;
    if (!image || !this.appImageFallback || image.src === this.appImageFallback) {
      return;
    }

    image.src = this.appImageFallback;
  }
}
