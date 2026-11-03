# Inventário do ABRii OS
_Gerado pela `/varredura`. Cada sócio atualiza só a seção da sua máquina. Nenhum segredo aqui: só nomes de variáveis._

---

# Mac do Adrian — varredura 02/11/2026

## Ferramentas

| Ferramenta | Pasta local | Repositório | Último commit | Vercel | Banco (Supabase) |
|---|---|---|---|---|---|
| Commander | `~/Desktop/abrii-commander` | abriiiacademy-rgb/abrii-commander (privado, criado 02/11) | 02/11 primeiro commit | `abrii-commander` (e `abrimob-commander`) | huwlikdosgknyfoykjwn |
| SGM | `~/Desktop/sgm-abrimob` | abriiiacademy-rgb/sgm-abrimob (privado, criado 02/11) | 02/11 primeiro commit | `sgm-abrimob` → sgm.abriiaceleradora.com.br | `.env.local` aponta para **agwhfxdokegptwlzdnah** (o schema `sgm` está em huwlikdosgknyfoykjwn — conferir) |
| GTIA / Jarvis | `~/Desktop/GTIA - Gestão de trafego com IA` | abriiiacademy-rgb/gtia | 22/10 "Média mensal…" | `gtia` | huwlikdosgknyfoykjwn (19 migrações locais, última `0019_fatos_cliente.sql`) |
| GTIA (cópias antigas) | `~/Desktop/gtia-prosperity` (27/08), `~/Desktop/gtia-CLIENTE` (04/08) | mesmo repo gtia | — | — | — |
| CRM (ABRiilead) | `~/Desktop/abrii-lead-crm` | abriiiacademy-rgb/abrii-lead-crm | 29/09 local (GitHub 24/10 → **local desatualizado**) | `abrii-lead-crm` → crm.abriiaceleradora.com.br | huwlikdosgknyfoykjwn |
| Worktesk | `~/Desktop/abrii-worktesk` | abriiiacademy-rgb/abrii-worktesk | 04/10 | `abrii-worktesk` | **yanvqenzhdzbuxrbeyit** (projeto próprio) |
| Portal / Hub | `~/Desktop/abrii-hub` | abriiiacademy-rgb/abrii-hub (privado, criado 02/11) | 02/11 primeiro commit | `abrii-hub` | huwlikdosgknyfoykjwn |
| Orion (excluído) | `~/Desktop/abrii-painel` | abriiiacademy-rgb/ABRii-Painel | 22/06 | `abrii-prod` | huwlikdosgknyfoykjwn — é a origem das Edge Functions `sync-meta-ads`/`sync-meta-ops` |
| Apply (fora do escopo) | `~/Desktop/abrii-apply` | abrii-apply | 29/06 | `abrii-apply` | huwlikdosgknyfoykjwn |
| Petrum Lead (CRM de terceiro) | `~/Desktop/petrum-lead-extracted` | sem git | — | `abrii-lead` | config.toml = zmakdhrixqwbsjqwkeio |
| Ferramenta Financeira? | não está neste Mac | abriiiacademy-rgb/abrii-asaas-webhook ("Asaas → **Firebase** do dashboard financeiro") | GitHub 27/10 | `abrii-financeiro`, `abrii-asaas-webhook` | **Firebase**, não Supabase |
| Supabase CLI solto | `~/Desktop/supabase` | — | — | — | linkado a **abrimob-central** (wjdqaexbjcpyptjcsxdd) |

Commander: um código só, publicado em duas instâncias na Vercel (`abrii-commander` e `abrimob-commander`) pelo `deploy.sh abrii|abrimob`. Não é duplicação.

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
1. ~~Commander, SGM e Hub sem git~~ → resolvido em 02/11: repositórios privados criados, `.gitignore` exclui `.env*`, `node_modules`, `.vercel`, `.next`; conferido no GitHub que nenhum `.env` subiu.
2. CRM local está ~1 mês atrás do GitHub (Railan commita, Adrian não puxa).
3. SGM local aponta para outro Supabase (agwhfxdokegptwlzdnah); existe ainda `abrimob-central` (wjdqaexbjcpyptjcsxdd). Qual é o oficial?
4. Três sincronizações Meta: `sync-meta-ads` (banco), `meta-ads-snapshot` (Vercel do CRM), e `sync-meta-ops` (desligada). GTIA coleta pela própria rotina `coletar`.
5. `crm.meta_cron_log` com 1,9 mi de linhas — log sem limpeza.
6. Edge Functions vivem no repositório do Orion (`abrii-painel`), que foi excluído do escopo.
7. Worktesk e Ferramenta Financeira identificados: Worktesk = Supabase yanvqenzhdzbuxrbeyit; Financeiro = Firebase + `abrii-financeiro` na Vercel.
8. Commander e GTIA não estão no portal (`public.tools`).

---

# Mac do Railan — varredura 03/11/2026

## Ferramentas (de escopo)

| Ferramenta | Pasta local | Repositório | Último commit local | Vercel | Banco |
|---|---|---|---|---|---|
| CRM (ABRiilead) | `~/Desktop/claude code/abrii-crm` | abriiiacademy-rgb/abrii-lead-crm | 10/08 (**local 3 meses atrás** — GitHub está em 03/11 10h07) | `abrii-lead-crm` → crm.abriiaceleradora.com.br | huwlikdosgknyfoykjwn |
| Worktesk | `~/Desktop/claude code/abrii-worktesk` | **railanjunior/abrii-worktesk** (privado — **NÃO existe `abriiiacademy-rgb/abrii-worktesk`**, mapa estava errado) | 27/10 "IA: Review e Daily em Sonnet 5.5 (de Opus)" | `abrii-worktesk` | yanvqenzhdzbuxrbeyit |
| Ferramenta Financeira (dashboard) | `~/Desktop/claude code/abrii-dashboard` | railanjunior/abrii-dashboard (público) | 27/10 "Radar: data 'conferido em' carimba automática" | GitHub Pages + `abrii-financeiro` na Vercel | **Firebase** (confirmado) |
| Ferramenta Financeira (webhook) | `~/Desktop/claude code/abrii-asaas-webhook` | abriiiacademy-rgb/abrii-asaas-webhook | 27/10 "Saldo: gatilho público ?refresh=1" | `abrii-asaas-webhook` | Firebase |

Fora do escopo mas rodando no mesmo Mac: `abrii-adops` (MCP próprio de Meta Ads, inativo desde 10/08), `abrii-apply`, `abrii-fieldwork`, `apple-drop` (produção, rifadrop.com.br), `chales-encanto`, `obraviva`, `couto-daily`, `star-daily`, `daily-abrii`, `abrii-review-automation`, `abrii-sdr-ote`, `ditudo-dashboard`, `pacto-app`, `abrimob-*` (vários entregáveis), `pratica-*`, `solartech-*`. Total: ~70 pastas em `~/Desktop/claude code/`.

Jarvis.py solto em `~/Desktop/jarvis.py` (projeto abandonado) — a memória do Railan registra **chaves Binance expostas** nesse arquivo, falta revogar.

Variáveis de ambiente (só nomes):
- Worktesk: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`, `DAILY_CRON_TOKEN`, `DISCORD_WEBHOOK_URL`, `ANTHROPIC_API_KEY`
- CRM (abrii-crm local): mesmas do Mac do Adrian
- abrii-dashboard: client-side (chaves Firebase no HTML)
- abrii-asaas-webhook: `FIREBASE_SERVICE_ACCOUNT`, `ASAAS_WEBHOOK_TOKEN`, `ASAAS_API_KEY`

## Vercel (conta `abriiiacademy-2260`)

55+ projetos ativos. Os de escopo: `abrii-lead-crm`, `abrii-worktesk`, `abrii-asaas-webhook`, `abrii-financeiro`, `abrii-commander`, `abrimob-commander`, `sgm-abrimob`, `gtia`, `abrii-hub`. Resto são entregáveis de clientes.

GitHub: `gh` logado como **railanjunior** (não como `abriiiacademy-rgb` — org acessada via colaborador).

## Conexões adicionais descobertas

- **GitHub Actions como backup dos crons Vercel**: `abrii-worktesk`, `couto-daily` e `star-daily` têm cada um `.github/workflows/daily-trigger.yml` disparando às 09:45 UTC (06:45 BRT) seg–sex, idempotente — se a Vercel já postou, vira no-op.
- **Firebase ↔ Dashboard**: confirmado. Asaas → `abrii-asaas-webhook` grava em `/asaas_inbox` do Firebase, dashboard lê e lança no financeiro. Cron Vercel `/api/saldo` diário 11h UTC.

## Automações

| Nome | O que faz | Gatilho | Onde roda | Ferramenta | Dono | Status |
|---|---|---|---|---|---|---|
| abrii-asaas-webhook /api/saldo | atualiza saldo da conta no dashboard | diário 11h UTC | cron Vercel | Financeiro | Railan | ativa |
| abrii-asaas-webhook ?refresh=1 | gatilho público (botão "atualizar agora" do dashboard) | manual via dashboard | Vercel | Financeiro | Railan | ativa |
| Worktesk GH Actions daily-trigger | backup do cron Vercel daily-cron | 09:45 UTC seg–sex | GitHub Actions | Worktesk | Railan | ativa |
| Couto daily GH Actions | mesma coisa | 09:45 UTC seg–sex | GitHub Actions | Couto Saúde | Railan | ativa |
| Star daily GH Actions | mesma coisa | 09:45 UTC seg–sex | GitHub Actions | Star Proteção | Railan | ativa |
| asaas-chat-humano | checa e-mail + chat Asaas por resposta humana sobre desbloqueio Pix | tarefa agendada Claude | este Mac | — | Railan | **órfã** (desbloqueio já resolveu, tarefa não foi apagada) |
| valida-badge-verde-facebook-ads | confirma que badge "Ao vivo" do CRM virou verde após cron | tarefa agendada Claude | este Mac | CRM | Railan | **órfã** (checagem única, já cumprida) |

Nenhum `crontab` local, nenhum `launchctl` custom (0 serviços fora do padrão macOS). Diferente do Mac do Adrian, que tem 3 launchds (todos desligados).

## Skills, comandos e MCPs locais

- `~/.claude/commands/`: **vazio**
- `~/.claude/agents/`: **vazio**
- `~/.claude/skills/`: 1 skill → `checkup` (DISC do prospect ABRimob via Instagram)
- `~/.claude/scheduled-tasks/`: 2 → `asaas-chat-humano`, `valida-badge-verde-facebook-ads` (ambas órfãs, ver tabela acima)
- `~/.claude/settings.json`: só marketplace de plugins `claude-plugins-official` e `agentPushNotifEnabled`
- Nenhum `.mcp.json` nas pastas de ferramentas de escopo (único `.mcp.json` encontrado: `squad de marketing - agentes/opensquad/`, fora de escopo)
- Conectores da conta claude.ai: Supabase (ABRii memória), Gmail, Google Drive, Notion, Canva, Meta Ads (Pipeboard), Google Ads (Pipeboard), ElevenLabs, Claude Docs — mesmo set do Adrian.

## Chats de desenvolvimento (Claude Code)

Pastas em `~/.claude/projects/`:
- `-Users-railanjunior-Desktop-claude-code` → **107 chats** (toda a atividade de dev acontece a partir dessa pasta única)
- `-Users-railanjunior-Documents-abrii-os` → este chat (criado hoje)

Chats mais recentes (últimas 48h, com peso em MB sinalizando sessões longas):
| Última sessão | Tamanho | Observação |
|---|---|---|
| 03/11 13:46 | 2,2 MB | atual (abrii-os) |
| 03/11 13:39 | 62 MB | sessão longa — provável CRM/dashboard |
| 03/11 13:11 | ~230 MB (3 arquivos) | pico de atividade |
| 03/11 08:33 | **789 MB** | maior chat já aberto |
| 02/11 18:08 | 188 MB | grande |
| 02/11 11:32 | 92 MB | — |

(O Claude Code do Railan nunca separou projetos por pasta — tudo abre a partir de `~/Desktop/claude code/`. Diferente do Adrian, que tem múltiplas pastas raiz.)

## Lacunas

1. **CRM local 3 meses atrás do GitHub** (último commit local 10/08, remoto 03/11 10h07). Railan edita direto na nuvem (Cursor/Chrome ou outro Mac?) e nunca puxa no Desktop. Mesma lacuna do Adrian, invertida.
2. **Worktesk em repo pessoal** (`railanjunior/abrii-worktesk`), não na org `abriiiacademy-rgb`. O mapa dizia que estava na org, estava errado. Mover pra org ou deixar?
3. **abrii-adops nunca saiu do rascunho** (último commit 10/08, meta era substituir Pipeboard). Decidir: retomar ou arquivar.
4. **Jarvis.py no Desktop** com chaves Binance expostas em texto puro — revogar na Binance e apagar o arquivo (projeto abandonado).
5. **2 tarefas agendadas órfãs** do Claude Code (`asaas-chat-humano`, `valida-badge-verde-facebook-ads`) — ambas já cumpriram, apagar.
6. **Chat gigante de 789 MB** em `~/.claude/projects/` — pode estar segurando contexto desnecessário; vale verificar se faz sentido arquivar.
7. **Dashboard vs abrii-financeiro na Vercel**: `abrii-dashboard` publica no GitHub Pages (HTML puro) **e** existe `abrii-financeiro` como projeto Vercel. Confirmar se é a mesma coisa ou dois deploys do mesmo HTML.
8. Nenhum `.mcp.json` nas ferramentas de escopo — se o CRM/Worktesk fossem ganhar MCP próprio (ex: Supabase apontado por projeto), ainda não aconteceu.

## Comparação com a varredura do Adrian

**Novo nesta varredura:**
- Firebase confirmado como banco da Ferramenta Financeira (dashboard HTML + webhook); cron `/api/saldo` descoberto.
- GH Actions `daily-trigger.yml` como backup dos crons Vercel das 3 dailies (Worktesk, Couto, Star).
- Repositório do Worktesk está em `railanjunior/abrii-worktesk`, não em `abriiiacademy-rgb/abrii-worktesk` como o mapa dizia.
- 2 tarefas agendadas do Claude Code (órfãs).
- Skill `checkup` global (DISC via Instagram).

**Confirma o que o Adrian viu:**
- CRM, Worktesk e Ferramenta Financeira todos no Mac do Railan, com os bancos esperados.
- Supabase huwlikdosgknyfoykjwn é o banco central do CRM.

**Sumiu/não existe:** Commander, SGM, GTIA, Hub (como esperado — são do Adrian).

**Duplicado/divergente:**
- Nome local da pasta do CRM: Adrian usa `abrii-lead-crm`, Railan usa `abrii-crm` — mesmo repo.
- Dashboard financeiro existe em 2 deploys: GitHub Pages + `abrii-financeiro` na Vercel.
- CRM: Adrian está 1 mês atrás do GitHub, Railan está 3 meses atrás. Nenhum dos 2 Macs tem a versão de produção.
