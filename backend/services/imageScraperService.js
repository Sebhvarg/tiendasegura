const axios = require('axios');
const cheerio = require('cheerio');

function buildQuery(name, brand = '') {
  const q = [brand, name].filter(Boolean).join(' ').trim();
  return encodeURIComponent(q);
}

/**
 * Extrae URLs de imagen con distintas estrategias de la página de Google Images
 */
function extractImageFromHtml(html) {
  const $ = cheerio.load(html);

  // 1) Buscar en scripts que contienen arrays con URLs
  let candidate = null;
  $('script').each((_, el) => {
    const txt = $(el).html() || '';
    if (txt.includes('http')) {
      const match = txt.match(/https?:\/\/[^"]+\.(?:jpg|jpeg|png|webp)[^\"]*/i);
      if (match && match[0]) {
        candidate = match[0];
        return false; // break
      }
    }
  });
  if (candidate) return candidate;

  // 2) Tomar la segunda imagen visible (la primera suele ser el logo)
  const imgs = $('img[src^="http"]');
  if (imgs.length > 1) {
    return $(imgs[1]).attr('src');
  }

  // 3) data-src
  const dataImg = $('[data-src^="http"]').first().attr('data-src');
  if (dataImg) return dataImg;

  return null;
}


async function searchProductImage(name, brand = '') {
  try {
    const query = buildQuery(name, brand);
    const url = `https://www.google.com/search?q=${query}&tbm=isch`;

    const res = await axios.get(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36'
      },
      timeout: 10000
    });

    const imageUrl = extractImageFromHtml(res.data);
    if (imageUrl) {
      console.log(`Imagen encontrada: ${imageUrl}`);
      return imageUrl;
    }

    console.log('No se encontró imagen en Google, probando Bing…');
    
  } catch (err) {
    console.error('Error buscando imagen:', err.message);
    return null;
  }
}

/**
 * Busca varias imágenes (hasta limit) y devuelve un array.
 */
async function searchProductImages(name, brand = '', limit = 5) {
  try {
    const query = buildQuery(name, brand);
    const url = `https://www.google.com/search?q=${query}&tbm=isch`;

    const res = await axios.get(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36'
      },
      timeout: 10000
    });

    const $ = cheerio.load(res.data);
    const results = new Set();

    // Recoger múltiples imágenes desde scripts
    $('script').each((_, el) => {
      if (results.size >= limit) return;
      const txt = $(el).html() || '';
      const matches = txt.match(/https?:\/\/[^"]+\.(?:jpg|jpeg|png|webp)[^\"]*/gi) || [];
      for (const m of matches) {
        if (results.size >= limit) break;
        results.add(m);
      }
    });

    // Rellenar con <img> visibles
    $('img[src^="http"]').each((_, el) => {
      if (results.size >= limit) return false;
      results.add($(el).attr('src'));
    });

    return Array.from(results).slice(0, limit);
  } catch (err) {
    console.error('Error buscando múltiples imágenes:', err.message);
    return [];
  }
}

module.exports = { searchProductImage, searchProductImages };
