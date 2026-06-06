import { HttpErrorResponse } from '@angular/common/http';

function flattenValidationErrors(errors: unknown): string[] {
  if (!errors || typeof errors !== 'object') {
    return [];
  }

  return Object.values(errors as Record<string, unknown>)
    .flatMap((value) => {
      if (Array.isArray(value)) {
        return value.filter((item): item is string => typeof item === 'string' && item.trim().length > 0);
      }

      return typeof value === 'string' && value.trim().length > 0 ? [value] : [];
    });
}

export function readHttpErrorMessage(error: unknown, fallback: string): string {
  if (!(error instanceof HttpErrorResponse)) {
    return fallback;
  }

  if (typeof error.error === 'string' && error.error.trim().length > 0) {
    return error.error;
  }

  if (typeof error.error?.message === 'string' && error.error.message.trim().length > 0) {
    return error.error.message;
  }

  const validationErrors = flattenValidationErrors(error.error?.errors);
  if (validationErrors.length > 0) {
    return validationErrors[0];
  }

  return fallback;
}
