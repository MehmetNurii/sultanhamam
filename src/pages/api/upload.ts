import type { APIRoute } from 'astro';
import { supabase } from '../../lib/supabase';

export const POST: APIRoute = async ({ request }) => {
    try {
        const formData = await request.formData();
        const file = formData.get('file') as File | null;
        const folder = (formData.get('folder') as string) || 'general';

        if (!file) {
            return new Response(JSON.stringify({ error: 'Dosya seçilmedi' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Max 5MB
        if (file.size > 5 * 1024 * 1024) {
            return new Response(JSON.stringify({ error: 'Dosya boyutu 5MB\'dan büyük olamaz' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Allowed types
        const allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml', 'image/gif'];
        if (!allowedTypes.includes(file.type)) {
            return new Response(JSON.stringify({ error: 'Desteklenmeyen dosya türü. JPG, PNG, WebP, SVG veya GIF yükleyin.' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Generate unique filename - derive extension from MIME type
        const mimeToExt: Record<string, string> = {
            'image/jpeg': 'jpg',
            'image/png': 'png',
            'image/webp': 'webp',
            'image/svg+xml': 'svg',
            'image/gif': 'gif',
        };
        const ext = mimeToExt[file.type] || file.name.split('.').pop() || 'jpg';
        const timestamp = Date.now();
        const random = Math.random().toString(36).substring(2, 8);
        const fileName = `${folder}/${timestamp}-${random}.${ext}`;

        // Read file as ArrayBuffer
        const arrayBuffer = await file.arrayBuffer();
        const uint8Array = new Uint8Array(arrayBuffer);

        // Upload to Supabase Storage
        const { data, error } = await supabase.storage
            .from('site-images')
            .upload(fileName, uint8Array, {
                contentType: file.type,
                upsert: false,
            });

        if (error) {
            console.error('Supabase Storage upload error:', error);
            return new Response(JSON.stringify({ error: `Yükleme hatası: ${error.message}` }), {
                status: 500,
                headers: { 'Content-Type': 'application/json' },
            });
        }

        // Get public URL
        const { data: urlData } = supabase.storage
            .from('site-images')
            .getPublicUrl(data.path);

        return new Response(JSON.stringify({
            success: true,
            url: urlData.publicUrl,
            path: data.path,
        }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
        });
    } catch (err) {
        console.error('Upload error:', err);
        return new Response(JSON.stringify({ error: 'Beklenmeyen bir hata oluştu' }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        });
    }
};
