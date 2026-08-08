// The preset catalogue, read at build time.
//
// scripts/build_library.py writes library/index.json beside the meshes it
// generates. This reads that original rather than a copy: web/sync-library.mjs
// copies the *artifacts* into public/ so the browser can fetch them, but the
// data has exactly one home. If the build script has not run, the site fails
// here rather than rendering a stale catalogue.

import { readFileSync } from 'node:fs';
import { join } from 'node:path';

// npm scripts run with web/ as the working directory, for both dev and build.
const INDEX_PATH = join(process.cwd(), '..', 'library', 'index.json');

// Must match INDEX_SCHEMA in scripts/build_library.py.
const SUPPORTED_SCHEMA = 1;

export type FileRef = { path: string; bytes: number } | null;

export interface Part {
	slug: string;
	label: string;
	size_mm: [number, number, number] | null;
	stl: FileRef;
	glb: FileRef;
	image: FileRef;
}

export interface Features {
	gridfinity_bottom: boolean;
	gridfinity_lid_top: boolean;
	gridfinity_magnets: boolean;
	sliced: boolean;
	slice_count: number | null;
	post: boolean;
	closed_post: boolean;
	stabilizers: boolean;
}

export interface Preset {
	name: string;
	title: string;
	fits: string;
	note: string | null;
	params: Record<string, string | number | boolean>;
	box_size_mm: [number, number, number] | null;
	features: Features;
	config: FileRef;
	notes: FileRef;
	parts: Part[];
	extra_images: { slug: string; image: FileRef }[];
}

export interface LibraryIndex {
	schema: number;
	generator: string;
	model_version: string;
	defaults: Record<string, string | number | boolean>;
	presets: Preset[];
}

const index: LibraryIndex = JSON.parse(readFileSync(INDEX_PATH, 'utf8'));

if (index.schema !== SUPPORTED_SCHEMA) {
	throw new Error(
		`library/index.json is schema ${index.schema} but this site reads ` +
			`schema ${SUPPORTED_SCHEMA}. Update web/src/lib/library.ts to match ` +
			'scripts/build_library.py, or rebuild the library.',
	);
}

export const library = index;
export const presets = index.presets;

/** Site URL for a path relative to library/, honouring the Pages base path. */
export function libraryUrl(base: string, path: string): string {
	return `${base.replace(/\/$/, '')}/library/${path}`;
}

export function formatBytes(n: number): string {
	if (n >= 1024 * 1024) return `${(n / 1024 / 1024).toFixed(1)} MB`;
	// Rounding to whole KB renders a 363-byte config.json as "0 KB", which reads
	// as a broken download rather than a small one.
	if (n >= 1024) return `${Math.round(n / 1024)} KB`;
	return `${n} bytes`;
}

/** Dimensions as printed text. Every consumer should say mm out loud: a GLB
 *  carries no unit convention, so the viewer beside this cannot imply scale. */
export function formatSize(mm: [number, number, number] | null): string {
	return mm ? `${mm.map((v) => v.toFixed(1)).join(' x ')} mm` : 'unknown';
}

/** Short badges describing what a preset turns on. */
export function featureLabels(f: Features): string[] {
	const out: string[] = [];
	if (f.gridfinity_bottom) out.push('Gridfinity base');
	if (f.gridfinity_lid_top) out.push('Gridfinity lid top');
	if (f.sliced) out.push(`Sliced x${f.slice_count ?? 2}`);
	if (!f.post) out.push('No post');
	if (f.closed_post) out.push('Closed post');
	return out;
}
