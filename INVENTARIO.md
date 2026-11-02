# Inventário do ABRii OS
_Gerado pela `/varredura`. Cada sócio atualiza só a seção da sua máquina. Nenhum segredo aqui: só nomes de variáveis._

---

# Mac do Adrian — varredura 02/11/2026

## Ferramentas

| Ferramenta | Pasta local | Repositório | Último commit | Vercel | Banco (Supabase) |
|---|---|---|---|---|---|
| Commander | `~/Desktop/abrii-commander` | **sem git** | — | `abrii-commander` (e `abrimob-commander`) | huwlikdosgknyfoykjwn |
| SGM | `~/Desktop/sgm-abrimob` | **sem git** | — | `sgm-abrimob` → sgm.abriiaceleradora.com.br | `.env.local` aponta para **agwhfxdokegptwlzdnah** (o schema `sgm` está em huwlikdosgknyfoykjwn — conferir) |
| GTIA / Jarvis | `~/Desktop/GTIA - Gestão de trafego com IA` | abriiiacademy-rgb/gtia | 22/10 "Média mensal…" | `gtia` | huwlikdosgknyfoykjwn (19 migrações locais, última `0019_fatos_cliente.sql`) |
| GTIA (cópias antigas) | `~/Desktop/gtia-prosperity` (27/08), `~/Desktop/gtia-CLIENTE` (04/08) | mesmo repo gtia | — | — | — |
| CRM (ABRiilead) | `~/Desktop/abrii-lead-crm` | abriiiacademy-rgb/abrii-lead-crm | 29/09 local (GitHub 24/10 → **local desatualizado**) | `abrii-lead-crm` → crm.abriiaceleradora.com.br | huwlikdosgknyfoykjwn |
| Worktesk | `~/Desktop/abrii-worktesk` | abriiiacademy-rgb/abrii-worktesk | 04/10 | `abrii-worktesk` | **yanvqenzhdzbuxrbeyit** (projeto próprio) |
| Portal / Hub | `~/Desktop/abrii-hub` | **sem git** | — | `abrii-hub` | huwlikdosgknyfoykjwn |
| Orion (excluído) | `~/Desktop/abrii-painel` | abriiiacademy-rgb/ABRii-Painel | 22/06 | `abrii-prod` | huwlikdosgknyfoykjwn — é a origem das Edge Functions `sync-meta-ads`/`sync-meta-ops` |
| Apply (fora do escopo) | `~/Desktop/abrii-apply` | abrii-apply | 29/06 | `abrii-apply` | huwlikdosgknyfoykjwn |
| Petrum Lead (CRM de terceiro) | `~/Desktop/petrum-lead-extracted` | sem git | — | `abrii-lead` | config.toml = zmakdhrixqwbsjqwkeio |
| Ferramenta Financeira? | não está neste Mac | abriiiacademy-rgb/abrii-asaas-webhook ("Asaas → **Firebase** do dashboard financeiro") | GitHub 27/10 | `abrii-financeiro`, `abrii-asaas-webhook` | **Firebase**, não Supabase |
| Supabase CLI solto | `~/Desktop/supabase` | — | — | — | linkado a **abrimob-central** (wjdqaexbjcpyptjcsxdd) |

Variáveis de ambiente (só nomes):
- Commander: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `CRM_SUPABASE_URL`, `CRM_SERVICE_ROLE_KEY`, `COMMANDER_WEBHOOK_TOKEN`
- CRM: `NEXT_PUBLIC_SUPABASE_*`, `SUPABASE_SERVICE_ROLE_KEY`, `META_APP_SECRET`, `META_CRM_API_TOKEN`, `META_PAGE_ACCESS_TOKEN`, `META_VERIFY_TOKEN`, `COMMANDER_WEBHOOK_TOKEN`, `NEXT_PUBLIC_COMMANDER_ABRII_URL`
- GTIA: `NEXT_PUBLIC_SUPABASE_*`, `SUPABASE_URL`, `SUPABASE_SECRET_KEY`, `ANTHROPIC_API_KEY`, `CRON_SECRET`
- SGM, Worktesk: só `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- Hub: `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`
- abrii-automation: `NTFY_TOPIC` (+ outras no `.env`)

Outros projetos Vercel da conta (entregáveis de clientes, não são ferramentas): solartech-*, abrimob-proposta-*, abrimob-calculadora, abrimob-gbp, star-daily, couto-daily, processos-comerciais-*, pratica-*, ditudo-dashboard, eco-network-abrii, abrii-placar, abrii-planejamento-2026, abrii-sdr-ote etc.

## Banco huwlikdosgknyfoykjwn (contagem aproximada)

| Schema | Tabelas | Maiores |
|---|---|---|
| `public` (Commander + Portal) | 58 + 4 visões `central_*` | metricas_meta_ads 3,5 mil; vendas 52; tenants 10 |
| `crm` | 68 | meta_cron_log **1,9 mi** (log sem limpeza); meta_ads_cron_log 36 mil; deals 3,6 mil; people 3,3 mil; tenants 21 |
| `meta_ops` (GTIA) | 33 | metricas_snapshots 30 mil; atividade 5,4 mil; timeline 1 mil; clientes 8; contas 19 |
| `sgm` | 9 + 2 visões | atividades 826; lancamentos_diarios 154; clientes 22 |
| `apply` | 15 | fora do escopo |

Portal: `public.tools` = Orion, ABRiilead, Worktesk, Apply, SGM; `public.tool_access` = 28 acessos. Commander e GTIA **não** estão no portal.

## Conexões

No banco (confirmadas):
- FK `sgm.clientes.tenant_id` → `crm.tenants`; FK `sgm.clientes.org_id` → `public.organizations`
- Trigger `public.vendas` → `sync_venda_to_sgm`
- Trigger `crm.tenant_members` → `sync_tenant_member_to_sgm_perfil`
- Função `sgm.provisionar_meu_acesso` (lê `public` + `crm`)

No código (novas, não aparecem no banco):
- **CRM → Commander**: deal marcado "Ganhou" dispara webhook para o Commander (`COMMANDER_WEBHOOK_TOKEN`).
- **Commander → CRM**: cron Vercel `/api/sync/crm` diário + credenciais `CRM_SUPABASE_URL`/`CRM_SERVICE_ROLE_KEY`.
- Commander `/api/sync-pixel-leads` diário.
- Asaas → Firebase (`abrii-asaas-webhook`) para o dashboard financeiro.

## Automações

| Nome | O que faz | Gatilho | Onde roda | Ferramenta | Dono | Status |
|---|---|---|---|---|---|---|
| sync-meta-ads | puxa métricas Meta para `crm.meta_ads_*` | a cada 2h | cron do banco + Edge Function | CRM (código no Orion) | ? | ativa (última 02/11 18h) |
| sync-meta-ops | puxa métricas Meta para `meta_ops` | 2h, min 15 | cron do banco + Edge Function | GTIA | ? | **desligada desde 09/09** |
| gtia-vigia | `meta_ops.disparar_rotina('vigia')` | 5 min | cron do banco | GTIA | Adrian | ativa |
| gtia-coletar | `meta_ops.disparar_rotina('coletar')` | 15 min | cron do banco | GTIA | Adrian | ativa |
| Diagnóstico Daily | diagnóstico de 11 clientes, entrega canal + push | diário 5h30 | `meta_ops.agendamentos` | GTIA | Adrian | ativa (29 execuções ok em 30 dias) |
| Lembretes pontuais GTIA | lembretes por cliente (W2, SolarTech, Roberto Carlos, Priorizze) | data única | `meta_ops.agendamentos` | GTIA | Adrian | concluídos (out/26) |
| Commander lembrete-sgm | lembrete de preenchimento do SGM | diário 11h UTC | cron Vercel | Commander | Adrian | ativa |
| Commander entrega | rotina de entrega | diário 12h UTC | cron Vercel | Commander | Adrian | ativa |
| Commander sync CRM | sincroniza CRM → Commander | diário 9h30 UTC | cron Vercel | Commander/CRM | Adrian | ativa |
| Commander sync-pixel-leads | leads do pixel | diário 9h45 UTC | cron Vercel | Commander | Adrian | ativa |
| CRM meta-leads-sync | leads de formulário Meta | 2 min | cron Vercel | CRM | Railan | ativa |
| CRM meta-ads-snapshot | snapshot Meta Ads | 15 min | cron Vercel | CRM | Railan | ativa — **3ª sincronização Meta** |
| CRM chatfuel (auto-assign-ia, detect-handoff, sync-pause-tag, reengagement) | automações Chatfuel/WhatsApp | 5–15 min | cron Vercel | CRM | Railan | ativa |
| CRM close-orphan-calls | fecha ligações órfãs (3C+) | 15 min | cron Vercel | CRM | Railan | ativa |
| CRM pgrst-health | checagem de saúde (debug) | 10 min | cron Vercel | CRM | Railan | ativa — rota de debug em produção |
| CRM meta-refresh-token | renova token Meta | domingo 4h UTC | cron Vercel | CRM | Railan | ativa |
| CRM billing-lifecycle | ciclo de cobrança Asaas | diário 11h UTC | cron Vercel | CRM | Railan | ativa |
| Worktesk review-cron | review semanal/formulário | diário 12h UTC | cron Vercel | Worktesk | ? | ativa |
| Worktesk daily-cron | daily do time | seg–sex 9h30 UTC | cron Vercel | Worktesk | ? | ativa |
| Worktesk daily-reminder | lembrete do daily | seg–sex 23h UTC | cron Vercel | Worktesk | ? | ativa |
| Apply playbooks/run | — | diário 12h UTC | cron Vercel | Apply (fora) | — | ativa |
| WhatsApp do dia (sender) | gera mensagens do dia e avisa no Mac/iPhone | seg–sex 8h40 | launchd local (`~/abrii-automation`) | GTIA/Meta | Adrian | **desligada** (último log 29/07) |
| Aviso Rotina Matinal 8h | notificação local + ntfy | seg–sex 8h15 | launchd local | GTIA | Adrian | **desligada** (último 12/08) |
| Aviso Diagnóstico 16h30 | notificação local + ntfy | seg–sex 16h45 | launchd local | GTIA | Adrian | **desligada** (último 12/08) |
| Lembrete pendências GTIA (WhatsApp por cliente + colisão no histórico) | lembra 2 pendências técnicas | agendada Claude | tarefa agendada do Claude | GTIA | Adrian | **desligada**, última 12/08 |
| Daily ABRimob | — | "Pode rodar o Daily" | chat | Meta Ads | Adrian | manual |
| Diagnóstico 16h30 (PDF) | — | "roda o diagnóstico" | chat | GTIA | Adrian | manual |
| Envio WhatsApp | dispara mensagens geradas | "envia as mensagens de hoje" | chat | — | Adrian | manual (depende do sender desligado) |
| Review Semanal Operacional | — | semanal | chat + Worktesk | Worktesk | ? | manual |
| Call de 15 dias | — | quinzenal | chat | — | ? | manual |

Não encontrado neste Mac: tarefa "Gerar docs formulários ABRimob" e a automação dos contratos de fechamento ABRimob.

## Chats de desenvolvimento (Claude Code)

Só 2 pastas em `~/.claude/projects`: `Desktop` (34 chats) e `abrii-os` (este). Todos os projetos foram abertos a partir do Desktop — o Claude não separa os chats por ferramenta.

| Ferramenta | Chat | Última sessão | O que foi feito por último |
|---|---|---|---|
| CRM ↔ Commander | 15df56a0 | 02/11 | webhook "Ganhou" do CRM → Commander configurado; teste pendente |
| CRM | d059dc70 | 29/10 | guia PDF de 4 páginas para cliente (Facebook Ads no CRM) |
| GTIA | ef07908e | 27/10 | ajustes no Daily 5h30 (média mensal, investimentos) — no ar |
| Worktesk | c247577c | 26/10 | logo, favicon, timer, deploy automático |
| CRM (leads Meta) | d90174a0 | 26/10 | recebimento de leads de formulário Meta |
| Petrum Lead | 4c61f364 | 26/10 | estrutura de CRM de terceiro, rotas removidas |
| Ferramenta financeira pessoal | c60aa266 | 26/10 | "Finanças Pessoais" (GitHub Pages) |
| ABRimob onboarding | 44d44062 | 26/10 | alterações no app abrimob-onboarding |
| SGM | 767e78bc | 23/10 | bug: metas gravam "2.677" como R$ 2,68 (formato BR) |
| Portal / Hub | 9de4c564 | 23/10 | retomada do contexto do Hub |
| Commander | f74fb192 | 21/10 | investigando `agenda_itens` (reuniões) |
| GTIA | 42ce3f8b | 24/09 | parou em erro de token expirado |
| GTIA (instalação) | 5ef43eaf | 27/08 | instalação inicial |
| Diversos (LPs, catálogos, apresentações, públicos Meta) | ~20 chats | 26/10 | entregáveis de clientes (W2, Priorizze, Germer, ECO, Núcleo) |

## MCPs
- Nenhum MCP local (`~/.claude/settings.json`, `~/.claude.json`, `claude_desktop_config.json` sem `mcpServers`; nenhum `.mcp.json`).
- Conectores da conta claude.ai: Supabase (ABRii memória), GTIA (MCP próprio), Meta Ads e Google Ads (Pipeboard), Gmail, Google Drive, Notion, Canva, ElevenLabs, Claude Docs; pendentes de login: Vercel, Jotform, Higgsfield, Microsoft 365, Meta Ads (oficial).
- Sem comandos, skills ou agentes globais em `~/.claude/`. Único comando: `/varredura` neste repo.

## Lacunas
1. Commander, SGM e Hub **sem git** — o código só existe neste Mac e na Vercel.
2. CRM local está ~1 mês atrás do GitHub (Railan commita, Adrian não puxa).
3. SGM local aponta para outro Supabase (agwhfxdokegptwlzdnah); existe ainda `abrimob-central` (wjdqaexbjcpyptjcsxdd). Qual é o oficial?
4. Três sincronizações Meta: `sync-meta-ads` (banco), `meta-ads-snapshot` (Vercel do CRM), e `sync-meta-ops` (desligada). GTIA coleta pela própria rotina `coletar`.
5. `crm.meta_cron_log` com 1,9 mi de linhas — log sem limpeza.
6. Edge Functions vivem no repositório do Orion (`abrii-painel`), que foi excluído do escopo.
7. Worktesk e Ferramenta Financeira identificados: Worktesk = Supabase yanvqenzhdzbuxrbeyit; Financeiro = Firebase + `abrii-financeiro` na Vercel.
8. Commander e GTIA não estão no portal (`public.tools`).

---

# Mac do Railan
_Ainda não rodado._
