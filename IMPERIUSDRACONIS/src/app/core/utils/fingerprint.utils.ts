/**
 * Genera una huella digital (fingerprint) única del navegador utilizando
 * características como resolución, canvas, agente de usuario y zona horaria.
 */
export async function getBrowserFingerprint(): Promise<string> {
  try {
    const components: string[] = [];

    // 1. Agente de usuario
    components.push(navigator.userAgent || '');

    // 2. Idioma del sistema
    components.push(navigator.language || '');

    // 3. Profundidad de color y dimensiones de pantalla
    components.push(`${screen.width}x${screen.height}x${screen.colorDepth}`);

    // 4. Zona horaria
    components.push(new Date().getTimezoneOffset().toString());

    // 5. Soporte de cookies y almacenamiento local
    components.push(navigator.cookieEnabled ? '1' : '0');
    components.push(typeof window.localStorage !== 'undefined' ? '1' : '0');
    components.push(typeof window.sessionStorage !== 'undefined' ? '1' : '0');

    // 6. Canvas Fingerprinting (muy efectivo para identificar hardware/drivers)
    try {
      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');
      if (ctx) {
        canvas.width = 200;
        canvas.height = 50;
        ctx.textBaseline = 'top';
        ctx.font = '14px "Arial", "Inter", sans-serif';
        ctx.textBaseline = 'alphabetic';
        ctx.fillStyle = '#f60';
        ctx.fillRect(125, 1, 62, 20);
        ctx.fillStyle = '#069';
        ctx.fillText('ImperiusDraconis,Auditoria;1.0', 2, 15);
        ctx.fillStyle = 'rgba(102, 204, 0, 0.7)';
        ctx.fillText('ImperiusDraconis,Auditoria;1.0', 4, 17);
        
        // Agregar algunas líneas y figuras
        ctx.strokeStyle = '#f0f';
        ctx.beginPath();
        ctx.arc(50, 25, 20, 0, Math.PI * 2, true);
        ctx.closePath();
        ctx.stroke();

        components.push(canvas.toDataURL());
      }
    } catch {
      // Ignorar errores de canvas (ej. bloqueos de privacidad agresivos)
    }

    const rawString = components.join('|||');
    return await hashStringSHA256(rawString);
  } catch (err) {
    console.error('Error generating fingerprint:', err);
    return 'fallback_' + Math.random().toString(36).substring(2, 15);
  }
}

/**
 * Genera un hash SHA-256 en formato hexadecimal de un string dado usando Web Crypto API.
 * Con fallback a un hash numérico rápido si no está en contexto seguro (HTTPS).
 */
async function hashStringSHA256(str: string): Promise<string> {
  try {
    if (window.crypto && window.crypto.subtle) {
      const msgBuffer = new TextEncoder().encode(str);
      const hashBuffer = await window.crypto.subtle.digest('SHA-256', msgBuffer);
      const hashArray = Array.from(new Uint8Array(hashBuffer));
      const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
      return hashHex;
    }
  } catch (e) {
    console.warn('Web Crypto API no disponible, usando fallback hash:', e);
  }

  // Fallback simple FNV-1a de 32 bits repetido para simular longitud
  return getSimpleHash(str);
}

function getSimpleHash(str: string): string {
  let h1 = 0x811c9dc5;
  let h2 = 0xcbf29ce4;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    h1 = Math.imul(h1 ^ char, 16777619);
    h2 = Math.imul(h2 ^ char, 1099511628211);
  }
  const part1 = (h1 >>> 0).toString(16).padStart(8, '0');
  const part2 = (h2 >>> 0).toString(16).padStart(8, '0');
  return `${part1}${part2}${part1}${part2}`; // Retorna 32 caracteres hexadecimales
}
