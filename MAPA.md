# Mapa das ferramentas e conexões
_Varredura do banco em 02/11/2026; atualizada pela `/varredura` do Mac do Adrian (02/11) e do Railan (03/11). Detalhes em `INVENTARIO.md`._

## Ferramentas

| Ferramenta | Onde | Cliente é | Dono | O que guarda |
|---|---|---|---|---|
| Commander | Supabase `public` | `tenants` | Adrian | Carteira, MRR, custo, vendas, pagamentos, entrega (`entrega_*`, `processos`), visões `central_*` |
| SGM | Supabase `sgm` | `clientes` | Adrian | Funil e lançamentos diários de venda do cliente |
| GTIA / Jarvis | Supabase `meta_ops` | `clientes` → `contas` | Adrian (confirmar) | Métricas Meta/Google, timeline, fatos, alertas, relatórios, rotinas agendadas |
| CRM (ABRiilead) | Supabase `crm` | `tenants` | Railan (Adrian tem acesso) | Leads, deals, atividades, integrações Meta/WhatsApp/Chatfuel/3C+, cobrança Asaas |
| Worktesk | abrii-worktesk.vercel.app — Supabase próprio **yanvqenzhdzbuxrbeyit** — repo `railanjunior/abrii-worktesk` (pessoal, **não** está na org) | ? | Railan | Horas do time, daily e review semanal operacional |
| Ferramenta Financeira | **Firebase** confirmado + Vercel `abrii-financeiro` (dashboard HTML) e `abrii-asaas-webhook` (Asaas → Firebase) | ? | Railan | DRE, recebimentos, saldo diário |
| Portal (hub de login) | Supabase `public` | `organizations` | ? | `tools` + `tool_access`: Worktesk, Orion, ABRiilead, Apply, SGM |

Fora do escopo: Apply (`apply`). Orion já foi decidido excluir.

## Conexões que JÁ existem
- `sgm.clientes.tenant_id` → `crm.tenants` (só 3 clientes preenchidos)
- `sgm.clientes.org_id` → `public.organizations` (portal)
- Trigger `public.vendas` → `sync_venda_to_sgm` (venda do Commander cai no SGM)
- Trigger `crm.tenant_members` → `sync_tenant_member_to_sgm_perfil` (usuário do CRM ganha acesso ao SGM)
- Função `sgm.provisionar_meu_acesso` usa `public` + `crm`
- `public.tenants.sgm_cliente_id` e `act_id` existem, mas estão vazios
- **CRM → Commander (no código):** deal "Ganhou" dispara webhook para o Commander
- **Commander → CRM (no código):** cron Vercel `/api/sync/crm` diário, 9h30 UTC
- Asaas → Firebase do financeiro (`abrii-asaas-webhook`)

## Conexões que FALTAM
- Commander ↔ GTIA
- Commander ↔ CRM no banco (hoje só por webhook/cron no código)
- Worktesk ↔ tudo
- Ferramenta Financeira ↔ tudo

## Automações encontradas até agora

| Nome | Gatilho | Onde roda | Ferramenta | Status |
|---|---|---|---|---|
| sync-meta-ads | a cada 2h | cron do banco + Edge Function | CRM | ativa |
| sync-meta-ops | a cada 2h (min 15) | cron do banco + Edge Function | GTIA | **desligada desde 09/09** |
| gtia-vigia | a cada 5 min | cron do banco | GTIA | ativa |
| gtia-coletar | a cada 15 min | cron do banco | GTIA | ativa |
| Diagnóstico Daily | diário, 5h30 | agenda do GTIA (`meta_ops.agendamentos`) | GTIA | ativa, último disparo 02/11 |
| Gerar docs formulários ABRimob | a cada hora | tarefa agendada do Claude | Drive | **desligada**, última execução abandonada (19/10) |
| Contratos de fechamento ABRimob | ? | "automação própria na nuvem" | ? | **não localizada** |
| Crons Vercel do Commander (lembrete-sgm, entrega, sync CRM, sync-pixel-leads) | diários | Vercel | Commander | ativas |
| Crons Vercel do CRM (meta-leads-sync, meta-ads-snapshot, chatfuel ×4, close-orphan-calls, billing, refresh-token, pgrst-health) | 2 min a semanal | Vercel | CRM | ativas |
| Crons Vercel do Worktesk (review-cron, daily-cron, daily-reminder, abrimob-form-reminder) | diários | Vercel | Worktesk | ativas |
| GH Actions daily-trigger (Worktesk, Couto, Star) | seg–sex 06:45 BRT | GitHub Actions, backup do cron Vercel, idempotente | Worktesk + dailies | ativas (descoberto 03/11) |
| abrii-asaas-webhook /api/saldo | diário 11h UTC | Vercel | Financeiro | ativa (descoberto 03/11) |
| WhatsApp do dia + avisos 8h15/16h45 | dias úteis | launchd no Mac do Adrian | GTIA | **desligadas** (ago) |
| Lembrete pendências GTIA | — | tarefa agendada do Claude | GTIA | **desligada** (12/08) |
| Daily ABRimob | frase "Pode rodar o Daily" | chat | Meta Ads | manual |
| Diagnóstico 16h30 (PDF) | frase "roda o diagnóstico" | chat | GTIA/Meta | manual |
| Review Semanal Operacional | semanal | chat + formulário Worktesk | Worktesk | manual |
| Call de 15 dias | quinzenal | chat (prompt) | — | manual |

Lista completa com dono e status: `INVENTARIO.md`.

## Pontos de atenção
- Sincronizações da Meta: `sync-meta-ads` (banco → `crm`), `meta-ads-snapshot` (Vercel do CRM) e `gtia-coletar` (GTIA). `sync-meta-ops` está desligada.
- Edge Functions estão no repositório do Orion (`abrii-painel`), excluído do escopo.
- Commander, SGM e Hub versionados desde 02/11 em repositórios privados (`abriiiacademy-rgb/abrii-commander`, `sgm-abrimob`, `abrii-hub`).
- `crm.meta_cron_log` com ~1,9 mi linhas sem limpeza.
- Visões `central_*` do Commander não respeitam RLS (rodam como dono).
- Nenhuma migração registrada no Supabase: o histórico de mudanças do banco só existe nos chats.
