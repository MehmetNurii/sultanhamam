import { createClient, type SupabaseClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.SUPABASE_URL || '';
const supabaseKey = import.meta.env.SUPABASE_KEY || '';

// Singleton Supabase client
let supabaseInstance: SupabaseClient | null = null;

function getSupabaseClient(): SupabaseClient {
    if (supabaseInstance) return supabaseInstance;

    if (!supabaseUrl || !supabaseKey) {
        throw new Error('Supabase client could not be initialized. Check your environment variables.');
    }

    supabaseInstance = createClient(supabaseUrl, supabaseKey);
    return supabaseInstance;
}

export const supabase = getSupabaseClient();

// Navigation types
export interface NavItem {
    title: string;
    url: string;
    visible: boolean;
    menu_type?: string;
    image_url?: string;
    children?: NavItem[];
}

// Get navigation items from site_settings JSON
export async function getHeaderNavigation(): Promise<NavItem[]> {
    try {
        const settings = await getSiteSettings();
        const json = settings.header_navigation;
        if (json) {
            return JSON.parse(json) as NavItem[];
        }
        return [];
    } catch (err) {
        console.error('Error parsing header navigation:', err);
        return [];
    }
}

export async function getFooterNavigation(): Promise<NavItem[]> {
    try {
        const settings = await getSiteSettings();
        const json = settings.footer_navigation;
        if (json) {
            return JSON.parse(json) as NavItem[];
        }
        return [];
    } catch (err) {
        console.error('Error parsing footer navigation:', err);
        return [];
    }
}

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

// Page Sections
export interface PageSection {
    id: number;
    page_slug: string;
    section_key: string;
    section_type: string;
    title: string | null;
    subtitle: string | null;
    description: string | null;
    button_text: string | null;
    button_url: string | null;
    image_url: string | null;
    extra_data: Record<string, unknown>;
    sort_order: number;
    visible: boolean;
    created_at: string;
    updated_at: string;
}

export async function getPageSections(pageSlug: string): Promise<PageSection[]> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('page_sections')
            .select('*')
            .eq('page_slug', pageSlug)
            .order('sort_order', { ascending: true });

        if (error) {
            console.error('Error fetching page sections:', error);
            return [];
        }

        return data || [];
    } catch (err) {
        console.error('Error in getPageSections:', err);
        return [];
    }
}

export async function getPageSection(pageSlug: string, sectionKey: string): Promise<PageSection | null> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('page_sections')
            .select('*')
            .eq('page_slug', pageSlug)
            .eq('section_key', sectionKey)
            .single();

        if (error) {
            console.error('Error fetching page section:', error);
            return null;
        }

        return data;
    } catch (err) {
        console.error('Error in getPageSection:', err);
        return null;
    }
}

export async function getAllPageSections(): Promise<PageSection[]> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('page_sections')
            .select('*')
            .order('page_slug', { ascending: true })
            .order('sort_order', { ascending: true });

        if (error) {
            console.error('Error fetching all page sections:', error);
            return [];
        }

        return data || [];
    } catch (err) {
        console.error('Error in getAllPageSections:', err);
        return [];
    }
}

export async function updatePageSection(id: number, updates: Partial<Omit<PageSection, 'id' | 'created_at' | 'updated_at'>>) {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('page_sections')
            .update({ ...updates, updated_at: new Date().toISOString() })
            .eq('id', id)
            .select();

        if (error) {
            console.error('Error updating page section:', error);
            return null;
        }

        return data;
    } catch (err) {
        console.error('Error in updatePageSection:', err);
        return null;
    }
}

export async function createPageSection(section: Omit<PageSection, 'id' | 'created_at' | 'updated_at'>) {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('page_sections')
            .insert(section)
            .select();

        if (error) {
            console.error('Error creating page section:', error);
            return null;
        }

        return data;
    } catch (err) {
        console.error('Error in createPageSection:', err);
        return null;
    }
}

export async function deletePageSection(id: number) {
    try {
        const client = getSupabaseClient();
        const { error } = await client
            .from('page_sections')
            .delete()
            .eq('id', id);

        if (error) {
            console.error('Error deleting page section:', error);
            return false;
        }

        return true;
    } catch (err) {
        console.error('Error in deletePageSection:', err);
        return false;
    }
}

// ============================================
// Services (Detail Pages) CRUD
// ============================================

export interface Service {
    id: number;
    slug: string;
    title: string;
    category: string | null;
    short_description: string | null;
    full_description: string | null;
    hero_image_url: string | null;
    icon_url: string | null;
    sidebar_links: Record<string, unknown>[];
    visible: boolean;
    sort_order: number;
    created_at: string;
    updated_at: string;
}

export interface ServiceFaq {
    id: number;
    service_id: number;
    question: string;
    answer: string;
    sort_order: number;
    created_at: string;
}

export async function getServices(): Promise<Service[]> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('services')
            .select('*')
            .order('sort_order');

        if (error) {
            console.error('Error fetching services:', error);
            return [];
        }
        return data || [];
    } catch (err) {
        console.error('Error in getServices:', err);
        return [];
    }
}

export async function getServiceById(id: number): Promise<Service | null> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('services')
            .select('*')
            .eq('id', id)
            .single();

        if (error) {
            console.error('Error fetching service:', error);
            return null;
        }
        return data;
    } catch (err) {
        console.error('Error in getServiceById:', err);
        return null;
    }
}

export async function createService(service: Omit<Service, 'id' | 'created_at' | 'updated_at'>): Promise<Service | null> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('services')
            .insert(service)
            .select()
            .single();

        if (error) {
            console.error('Error creating service:', error);
            return null;
        }
        return data;
    } catch (err) {
        console.error('Error in createService:', err);
        return null;
    }
}

export async function updateService(id: number, updates: Partial<Omit<Service, 'id' | 'created_at' | 'updated_at'>>): Promise<Service | null> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('services')
            .update({ ...updates, updated_at: new Date().toISOString() })
            .eq('id', id)
            .select()
            .single();

        if (error) {
            console.error('Error updating service:', error);
            return null;
        }
        return data;
    } catch (err) {
        console.error('Error in updateService:', err);
        return null;
    }
}

export async function deleteService(id: number): Promise<boolean> {
    try {
        const client = getSupabaseClient();
        const { error } = await client
            .from('services')
            .delete()
            .eq('id', id);

        if (error) {
            console.error('Error deleting service:', error);
            return false;
        }
        return true;
    } catch (err) {
        console.error('Error in deleteService:', err);
        return false;
    }
}

// Service FAQs CRUD

export async function getServiceFaqs(serviceId: number): Promise<ServiceFaq[]> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('service_faqs')
            .select('*')
            .eq('service_id', serviceId)
            .order('sort_order');

        if (error) {
            console.error('Error fetching service FAQs:', error);
            return [];
        }
        return data || [];
    } catch (err) {
        console.error('Error in getServiceFaqs:', err);
        return [];
    }
}

export async function createServiceFaq(faq: Omit<ServiceFaq, 'id' | 'created_at'>): Promise<ServiceFaq | null> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('service_faqs')
            .insert(faq)
            .select()
            .single();

        if (error) {
            console.error('Error creating FAQ:', error);
            return null;
        }
        return data;
    } catch (err) {
        console.error('Error in createServiceFaq:', err);
        return null;
    }
}

export async function updateServiceFaq(id: number, updates: Partial<Omit<ServiceFaq, 'id' | 'created_at'>>): Promise<ServiceFaq | null> {
    try {
        const client = getSupabaseClient();
        const { data, error } = await client
            .from('service_faqs')
            .update(updates)
            .eq('id', id)
            .select()
            .single();

        if (error) {
            console.error('Error updating FAQ:', error);
            return null;
        }
        return data;
    } catch (err) {
        console.error('Error in updateServiceFaq:', err);
        return null;
    }
}

export async function deleteServiceFaq(id: number): Promise<boolean> {
    try {
        const client = getSupabaseClient();
        const { error } = await client
            .from('service_faqs')
            .delete()
            .eq('id', id);

        if (error) {
            console.error('Error deleting FAQ:', error);
            return false;
        }
        return true;
    } catch (err) {
        console.error('Error in deleteServiceFaq:', err);
        return false;
    }
}
