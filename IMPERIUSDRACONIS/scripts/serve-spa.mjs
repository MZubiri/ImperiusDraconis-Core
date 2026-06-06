import { createReadStream } from 'node:fs';
import { access, stat } from 'node:fs/promises';
import { createServer } from 'node:http';
import { extname, join, normalize } from 'node:path';

const port = Number(process.env.PORT || 4200);
const root = join(process.cwd(), 'dist', 'imperiusdraconis-web', 'browser');
const indexPath = join(root, 'index.html');

const mimeTypes = {
  '.css': 'text/css; charset=utf-8',
  '.html': 'text/html; charset=utf-8',
  '.ico': 'image/x-icon',
  '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.map': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.svg': 'image/svg+xml; charset=utf-8',
  '.txt': 'text/plain; charset=utf-8',
  '.webp': 'image/webp'
};

function sendFile(response, filePath) {
  const extension = extname(filePath).toLowerCase();
  response.writeHead(200, {
    'Cache-Control': 'no-store, max-age=0',
    'Content-Type': mimeTypes[extension] ?? 'application/octet-stream'
  });

  createReadStream(filePath).pipe(response);
}

async function resolveFilePath(urlPath) {
  const requestPath = decodeURIComponent(urlPath.split('?')[0] || '/');
  const safePath = normalize(join(root, requestPath));

  if (!safePath.startsWith(root)) {
    return null;
  }

  try {
    const fileStat = await stat(safePath);
    if (fileStat.isFile()) {
      return safePath;
    }

    const nestedIndex = join(safePath, 'index.html');
    await access(nestedIndex);
    return nestedIndex;
  } catch {
    if (extname(requestPath)) {
      return null;
    }

    return indexPath;
  }
}

const server = createServer(async (request, response) => {
  const filePath = await resolveFilePath(request.url || '/');
  if (!filePath) {
    response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
    response.end('Not found');
    return;
  }

  sendFile(response, filePath);
});

server.listen(port, '127.0.0.1', () => {
  console.log(`SPA server listening on http://127.0.0.1:${port}`);
});
