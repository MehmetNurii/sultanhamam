import { createClient, type SupabaseClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.SUPABASE_URL || '';
const supabaseKey = import.meta.env.SUPABASE_KEY || '';

// Lazy initialization with singleton pattern
let supabaseInstance: SupabaseClient | null = null;

function getSupabaseClient(): SupabaseClient {
    if (!supabaseInstance && supabaseUrl && supabaseKey) {
        supabaseInstance = createClient(supabaseUrl, supabaseKey);
    }
    if (!supabaseInstance) {
        throw new Error('Supabase client could not be initialized. Check your environment variables.');
    }
    return supabaseInstance;
}

export const supabase = getSupabaseClient();

// Helper functions for admin panel

// Site Settings
export async function getSiteSettings() {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('site_settings')
            .select('*');

        if (error) {
            console.error('Error fetching site settings:', error);
            return {};
        }

        // Convert array to object
        return data.reduce((acc: Record<string, string>, item: { key: string; value: string }) => {
            acc[item.key] = item.value;
            return acc;
        }, {});
    } catch (err) {
        console.error('Error in getSiteSettings:', err);
        return {};
    }
}

export async function updateSiteSetting(key: string, value: string) {
    const { data, error } = await supabase
        .from('site_settings')
        .update({ value, updated_at: new Date().toISOString() })
        .eq('key', key)
        .select();

    if (error) {
        console.error('Error updating site setting:', error);
        return null;
    }

    return data;
}

// Pages
export async function getPages() {
    const { data, error } = await supabase
        .from('pages')
        .select('*')
        .order('id', { ascending: true });

    if (error) {
        console.error('Error fetching pages:', error);
        return [];
    }

    return data;
}

export async function getPageById(id: number) {
    const { data, error } = await supabase
        .from('pages')
        .select('*')
        .eq('id', id)
        .single();

    if (error) {
        console.error('Error fetching page:', error);
        return null;
    }

    return data;
}

export async function updatePage(id: number, updates: {
    title?: string;
    meta_title?: string;
    meta_description?: string;
    visible?: boolean;
}) {
    const { data, error } = await supabase
        .from('pages')
        .update({ ...updates, updated_at: new Date().toISOString() })
        .eq('id', id)
        .select();

    if (error) {
        console.error('Error updating page:', error);
        return null;
    }

    return data;
}

// Navigation
export async function getNavigation() {
    const { data, error } = await supabase
        .from('navigation')
        .select('*')
        .order('sort_order', { ascending: true });

    if (error) {
        console.error('Error fetching navigation:', error);
        return [];
    }

    return data;
}

export async function updateNavItem(id: number, updates: {
    title?: string;
    url?: string;
    sort_order?: number;
    visible?: boolean;
}) {
    const { data, error } = await supabase
        .from('navigation')
        .update({ ...updates, updated_at: new Date().toISOString() })
        .eq('id', id)
        .select();

    if (error) {
        console.error('Error updating nav item:', error);
        return null;
    }

    return data;
}

export async function createNavItem(item: {
    title: string;
    url: string;
    sort_order: number;
    visible: boolean;
}) {
    const { data, error } = await supabase
        .from('navigation')
        .insert(item)
        .select();

    if (error) {
        console.error('Error creating nav item:', error);
        return null;
    }

    return data;
}

export async function deleteNavItem(id: number) {
    const { error } = await supabase
        .from('navigation')
        .delete()
        .eq('id', id);

    if (error) {
        console.error('Error deleting nav item:', error);
        return false;
    }

    return true;
}
