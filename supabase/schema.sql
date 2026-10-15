-- Run in Supabase SQL Editor after creating a project.
create extension if not exists pgcrypto;
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 100),
  description text not null check (char_length(description) between 1 and 600),
  category text not null default 'Other',
  tags text[] not null default '{}',
  url text,
  year integer check (year is null or year between 1900 and 2200),
  status text not null default 'in_progress' check (status in ('completed','in_progress')),
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);
alter table public.projects enable row level security;
-- Anonymous visitors and signed-in viewers see completed projects only.
drop policy if exists "Public can read completed projects" on public.projects;
create policy "Public can read completed projects" on public.projects for select using (status = 'completed');
-- The owner identity is set in Supabase Auth and injected as a SQL literal below.
-- Replace OWNER_AUTH_USER_UUID with your Auth user's UUID before running these policies.
drop policy if exists "Owner can read all projects" on public.projects;
create policy "Owner can read all projects" on public.projects for select to authenticated using (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid);
drop policy if exists "Owner can insert projects" on public.projects;
create policy "Owner can insert projects" on public.projects for insert to authenticated with check (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid and owner_id = auth.uid());
drop policy if exists "Owner can update projects" on public.projects;
create policy "Owner can update projects" on public.projects for update to authenticated using (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid) with check (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid and owner_id = auth.uid());
drop policy if exists "Owner can delete projects" on public.projects;
create policy "Owner can delete projects" on public.projects for delete to authenticated using (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid);
grant select on public.projects to anon, authenticated;
grant insert, update, delete on public.projects to authenticated;
