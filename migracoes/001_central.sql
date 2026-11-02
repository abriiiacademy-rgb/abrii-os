-- =====================================================================
-- ABRii OS — Camada central (identidade única do cliente + visões)
-- Projeto Supabase: huwlikdosgknyfoykjwn ("ABRii memória")
-- 100% ADITIVO: não altera nem apaga nenhuma tabela existente.
-- Rodar no SQL Editor do Supabase (ou via Claude Code com acesso de escrita).
-- =====================================================================

begin;

-- 1) CLIENTE ÚNICO -------------------------------------------------------
create table if not exists public.central_cliente (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null unique,
  status      text not null default 'ativo',     -- ativo | pausado | churned
  observacao  text,
  criado_em   timestamptz not null default now()
);
comment on table public.central_cliente is
  'ABRii OS: identidade única do cliente, comum a todas as ferramentas.';

-- 2) VÍNCULOS: o ID do cliente em cada ferramenta ------------------------
create table if not exists public.central_vinculo (
  id          uuid primary key default gen_random_uuid(),
  cliente_id  uuid not null references public.central_cliente(id) on delete cascade,
  sistema     text not null check (sistema in
                ('commander','gtia','crm','sgm','worktesk','financeiro')),
  ref_id      uuid not null,
  ref_nome    text,
  confirmado  boolean not null default true,     -- false = conferir com o time
  criado_em   timestamptz not null default now(),
  unique (sistema, ref_id)
);
comment on table public.central_vinculo is
  'ABRii OS: liga o cliente único ao ID dele em cada ferramenta '
  '(commander=public.tenants, gtia=meta_ops.clientes, crm=crm.tenants, '
  'sgm=sgm.clientes, worktesk=Worktesk, financeiro=Ferramenta Financeira).';
create index if not exists central_vinculo_cliente_idx on public.central_vinculo(cliente_id);

-- Acesso: só admin (mesmo padrão do Commander)
alter table public.central_cliente enable row level security;
alter table public.central_vinculo enable row level security;
create policy central_cliente_admin on public.central_cliente
  for all using (current_user_role() = 'admin') with check (current_user_role() = 'admin');
create policy central_vinculo_admin on public.central_vinculo
  for all using (current_user_role() = 'admin') with check (current_user_role() = 'admin');

-- 3) CARGA INICIAL (a partir da varredura de 02/11/2026) -----------------
-- Fora: registros de teste (Adrian teste, Empresa Modelo, teste, voyodi…,
-- Aula, Conta aulas), contas internas da ABRii e o Apply (fora do escopo).
insert into public.central_cliente(nome) values
('3F Móveis Sob Medida'),('ABRimob'),('Chalés Encanto'),('Couto Saúde Ambiental'),
('Dr. Pedro Furtado'),('Edmilson Corretor'),('Ega'),('Eletromotos'),('Fersary Imóveis'),
('Imobiliária Muller'),('Josiane Adam Corretora'),('LisoLaser'),('Lypedepyl'),
('Nações Pizzaria'),('Priorizze Móveis'),('Roberto Carlos Corretor'),('Shoppcell Eletrônicos'),
('Sirius Inkaza'),('Solar Tech'),('Thiago Carneiro Corretor'),('Vert Eletros e Metais'),
('Victor Santos'),('W2 Engenharia'),('Dle Móveis'),('Fran Podóloga'),('Imobiliária Vento Norte'),
('Pizzaria Pertutti'),('Sidnei Corretor')
on conflict (nome) do nothing;

with m(cliente, sistema, ref_nome) as (values
('3F Móveis Sob Medida','crm','3F Móveis Sob Medida'),('3F Móveis Sob Medida','gtia','3F Sob Medida'),
('ABRimob','commander','ABRimob'),('ABRimob','crm','ABRimob'),('ABRimob','gtia','ABRimob'),('ABRimob','sgm','ABRimob'),
('Chalés Encanto','commander','Chalés Encanto'),('Chalés Encanto','gtia','Chalés Encanto'),
('Couto Saúde Ambiental','crm','Couto Saúde Ambiental'),
('Couto Saúde Ambiental','sgm','Couto Saúde Ambiental'),('Couto Saúde Ambiental','sgm','Couto Saude Ambiental'),
('Dr. Pedro Furtado','commander','Dr. Pedro Furtado'),
('Edmilson Corretor','crm','Edmilson - Corretor UNI'),('Edmilson Corretor','gtia','Edmilson Corretor'),
('Edmilson Corretor','sgm','Edmilson Corretor'),('Edmilson Corretor','sgm','Edmilson - Corretor UNI'),
('Ega','crm','Ega'),('Ega','sgm','Ega'),
('Eletromotos','crm','Eletro Motos LTDA'),('Eletromotos','sgm','Eletro Motos LTDA'),('Eletromotos','gtia','Eletromotos'),
('Fersary Imóveis','gtia','Alexandre Fersary'),
('Imobiliária Muller','crm','Imobiliária Muller'),('Imobiliária Muller','sgm','Imobiliária Muller'),('Imobiliária Muller','gtia','Muller Imóveis'),
('Josiane Adam Corretora','crm','Josiane Adam Corretora'),('Josiane Adam Corretora','gtia','Josiane Adam Corretora'),('Josiane Adam Corretora','sgm','Josiane Adam Corretora'),
('LisoLaser','crm','Lisô Laser'),
('Lypedepyl','commander','Lypedepyl'),('Lypedepyl','crm','Lypedepyl'),('Lypedepyl','gtia','Lypedepyl'),('Lypedepyl','sgm','Lypedepyl'),
('Nações Pizzaria','commander','Nações Pizzaria'),('Nações Pizzaria','gtia','Nações Pizzaria'),
('Priorizze Móveis','commander','Priorizze móveis planejaods'),('Priorizze Móveis','crm','Priorizze'),
('Priorizze Móveis','gtia','Priorizze Móveis'),('Priorizze Móveis','sgm','Priorizze'),
('Roberto Carlos Corretor','crm','Roberto Carlos'),('Roberto Carlos Corretor','gtia','Roberto Carlos Corretor'),('Roberto Carlos Corretor','sgm','Roberto Carlos Corretor'),
('Shoppcell Eletrônicos','crm','SHOPPCELL ELETRONICOS'),('Shoppcell Eletrônicos','sgm','SHOPPCELL ELETRONICOS'),
('Sirius Inkaza','crm','Sirius Inkaza'),('Sirius Inkaza','sgm','Sirius Inkaza'),
('Solar Tech','gtia','Solar Tech'),
('Thiago Carneiro Corretor','crm','Thiago Carneiro'),('Thiago Carneiro Corretor','gtia','Thiago Carneiro Corretor'),('Thiago Carneiro Corretor','sgm','Thiago corretor'),
('Vert Eletros e Metais','commander','Vert Eletros e Metais'),('Vert Eletros e Metais','crm','Vert Eletro e Metais'),
('Victor Santos','crm','Victor Santos'),('Victor Santos','gtia','Victor Santos'),('Victor Santos','sgm','Victor Santos'),
('W2 Engenharia','commander','W2 Engenharia'),('W2 Engenharia','crm','W2 Engenharia'),
('W2 Engenharia','gtia','W2 Engenharia'),('W2 Engenharia','sgm','W2 Engenharia'),
('Dle Móveis','gtia','Dle Móveis'),
('Fran Podóloga','gtia','Fran Podóloga'),
('Imobiliária Vento Norte','sgm','Imobiliária Vento Norte'),
('Pizzaria Pertutti','gtia','Pizzaria Pertutti'),('Sidnei Corretor','sgm','Sidnei Corretor')
), refs as (
  select 'commander' s, id, nome n from public.tenants
  union all select 'gtia',  id, nome from meta_ops.clientes
  union all select 'crm',   id, name from crm.tenants where deleted_at is null
  union all select 'sgm',   id, nome from sgm.clientes
)
insert into public.central_vinculo(cliente_id, sistema, ref_id, ref_nome, confirmado)
select c.id, m.sistema, r.id, r.n,
       m.cliente not in ('Fersary Imóveis','Edmilson Corretor')   -- conferir
from m
join public.central_cliente c on c.nome = m.cliente
join refs r on r.s = m.sistema and r.n = m.ref_nome
on conflict (sistema, ref_id) do nothing;

-- 4) LINHA DO TEMPO ÚNICA (tudo que aconteceu com o cliente, de toda ferramenta)
create or replace view public.central_linha_do_tempo
with (security_invoker = true) as
select v.cliente_id, 'gtia'::text origem, t.criado_em quando, t.tipo,
       t.titulo, t.detalhe, t.autor
from meta_ops.timeline t
left join meta_ops.contas ct on ct.id = t.conta_id
join public.central_vinculo v on v.sistema = 'gtia'
     and v.ref_id = coalesce(t.cliente_id, ct.cliente_id)
union all
select v.cliente_id, 'gtia', f.criado_em, 'fato', 'Fato do cliente', f.texto, f.autor
from meta_ops.fatos_cliente f
join public.central_vinculo v on v.sistema = 'gtia' and v.ref_id = f.cliente_id
union all
select v.cliente_id, 'commander', e.registrado_em, e.tipo, e.setor, e.descricao, e.registrado_por
from public.eventos e
join public.central_vinculo v on v.sistema = 'commander' and v.ref_id = e.tenant_id
union all
select v.cliente_id, 'sgm', a.criado_em, a.acao, a.referencia, a.detalhe, a.user_id::text
from sgm.atividades a
join public.central_vinculo v on v.sistema = 'sgm' and v.ref_id = a.cliente_id
union all
select v.cliente_id, 'crm', a.created_at, a.type, a.title, a.content, a.created_by::text
from crm.activities a
join public.central_vinculo v on v.sistema = 'crm' and v.ref_id = a.tenant_id
where a.deleted_at is null;

comment on view public.central_linha_do_tempo is
  'ABRii OS: linha do tempo única do cliente (GTIA, fatos, Commander, SGM, CRM).';

-- 5) CLIENTE 360 (uma linha por cliente, cruzando todas as ferramentas) ---
create or replace view public.central_cliente_360
with (security_invoker = true) as
select
  c.id as cliente_id, c.nome, c.status,
  -- Commander (receita e entrega)
  cmd.mensalidade, cmd.modelo_receita, cmd.custo_mensal,
  cmd.mensalidade - cmd.custo_mensal                         as margem_mensal,
  cmd.entrou_em,
  ent.etapa                                                  as etapa_entrega,
  ent.entrou_etapa_em,
  -- CRM ABRiilead (resultado comercial do cliente)
  crm.deals_abertos, crm.vendas_30d, crm.valor_vendido_30d,
  -- SGM (lançamentos do cliente)
  sgm.vendido_30d_sgm, sgm.ultimo_lancamento,
  -- GTIA (tráfego) — números de mídia ficam no GTIA (consultar_carteira)
  gt.contas_anuncio,
  -- Último movimento em qualquer ferramenta
  lt.ultimo_evento_em, lt.ultimo_evento_origem,
  -- Em quais ferramentas o cliente existe
  sis.sistemas
from public.central_cliente c
left join lateral (
  select string_agg(distinct v.sistema, ', ' order by v.sistema) sistemas
  from public.central_vinculo v where v.cliente_id = c.id) sis on true
left join lateral (
  select t.mensalidade, t.modelo_receita, t.custo_mensal, t.entrou_em, t.id
  from public.central_vinculo v join public.tenants t on t.id = v.ref_id
  where v.cliente_id = c.id and v.sistema = 'commander' limit 1) cmd on true
left join lateral (
  select e.etapa, e.entrou_etapa_em from public.entrega_cards e
  where e.tenant_id = cmd.id order by e.entrou_etapa_em desc nulls last limit 1) ent on true
left join lateral (
  select count(*) filter (where d.status = 'open') deals_abertos,
         count(*) filter (where d.status = 'won' and d.closed_at >= now() - interval '30 days') vendas_30d,
         coalesce(sum(d.value) filter (where d.status = 'won' and d.closed_at >= now() - interval '30 days'),0) valor_vendido_30d
  from public.central_vinculo v join crm.deals d on d.tenant_id = v.ref_id and d.deleted_at is null
  where v.cliente_id = c.id and v.sistema = 'crm') crm on true
left join lateral (
  select coalesce(sum(l.valor_vendido) filter (where l.data >= current_date - 30),0) vendido_30d_sgm,
         max(l.data) ultimo_lancamento
  from public.central_vinculo v join sgm.lancamentos_diarios l on l.cliente_id = v.ref_id
  where v.cliente_id = c.id and v.sistema = 'sgm') sgm on true
left join lateral (
  select count(*) contas_anuncio
  from public.central_vinculo v join meta_ops.contas ct on ct.cliente_id = v.ref_id
  where v.cliente_id = c.id and v.sistema = 'gtia') gt on true
left join lateral (
  select max(quando) ultimo_evento_em,
         (array_agg(origem order by quando desc))[1] ultimo_evento_origem
  from public.central_linha_do_tempo l where l.cliente_id = c.id) lt on true;

comment on view public.central_cliente_360 is
  'ABRii OS: visão 360 de cada cliente cruzando Commander, CRM, SGM e GTIA.';

commit;

-- CONFERÊNCIA ------------------------------------------------------------
-- select sistema, count(*) from public.central_vinculo group by 1;
-- select * from public.central_cliente_360 order by nome;
-- select * from public.central_vinculo where not confirmado;   -- revisar
-- select c.nome from public.central_cliente c
--   where not exists (select 1 from public.central_vinculo v
--                     where v.cliente_id = c.id and v.sistema = 'commander');  -- faltam no Commander
