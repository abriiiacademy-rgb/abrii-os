# Mapa das ferramentas e conexões
_Varredura do banco em 02/11/2026. Atualizar a cada mudança (rodar `/varredura`)._

## Ferramentas

| Ferramenta | Onde | Cliente é | Dono | O que guarda |
|---|---|---|---|---|
| Commander | Supabase `public` | `tenants` | Adrian | Carteira, MRR, custo, vendas, pagamentos, entrega (`entrega_*`, `processos`), visões `central_*` |
| SGM | Supabase `sgm` | `clientes` | Adrian | Funil e lançamentos diários de venda do cliente |
| GTIA / Jarvis | Supabase `meta_ops` | `clientes` → `contas` | Adrian (confirmar) | Métricas Meta/Google, timeline, fatos, alertas, relatórios, rotinas agendadas |
| CRM (ABRiilead) | Supabase `crm` | `tenants` | Railan (Adrian tem acesso) | Leads, deals, atividades, integrações Meta/WhatsApp/Chatfuel/3C+, cobrança Asaas |
| Worktesk | abrii-worktesk.vercel.app — **banco não está no ABRii memória** | ? | ? | Horas do time, review semanal operacional |
| Ferramenta Financeira | outro banco (Railan) | ? | Railan | DRE, recebimentos |
| Portal (hub de login) | Supabase `public` | `organizations` | ? | `tools` + `tool_access`: Worktesk, Orion, ABRiilead, Apply, SGM |

Fora do escopo: Apply (`apply`). Orion já foi decidido excluir.

## Conexões que JÁ existem
- `sgm.clientes.tenant_id` → `crm.tenants` (só 3 clientes preenchidos)
- `sgm.clientes.org_id` → `public.organizations` (portal)
- Trigger `public.vendas` → `sync_venda_to_sgm` (venda do Commander cai no SGM)
- Trigger `crm.tenant_members` → `sync_tenant_member_to_sgm_perfil` (usuário do CRM ganha acesso ao SGM)
- Função `sgm.provisionar_meu_acesso` usa `public` + `crm`
- `public.tenants.sgm_cliente_id` e `act_id` existem, mas estão vazios

## Conexões que FALTAM
- Commander ↔ GTIA
- Commander ↔ CRM
- Worktesk ↔ tudo
- Ferramenta Financeira ↔ tudo

## Automações encontradas até agora

| Nome | Gatilho | Onde roda | Ferramenta | Status |
|---|---|---|---|---|
| sync-meta-ads | a cada 2h | cron do banco + Edge Function | CRM | ativa |
| sync-meta-ops | a cada 2h (min 15) | cron do banco + Edge Function | GTIA | ativa |
| gtia-vigia | a cada 5 min | cron do banco | GTIA | ativa |
| gtia-coletar | a cada 15 min | cron do banco | GTIA | ativa |
| Diagnóstico Daily | diário, 5h30 | agenda do GTIA (`meta_ops.agendamentos`) | GTIA | ativa, último disparo 02/11 |
| Gerar docs formulários ABRimob | a cada hora | tarefa agendada do Claude | Drive | **desligada**, última execução abandonada (19/10) |
| Contratos de fechamento ABRimob | ? | "automação própria na nuvem" | ? | **não localizada** |
| Daily ABRimob | frase "Pode rodar o Daily" | chat | Meta Ads | manual |
| Diagnóstico 16h30 (PDF) | frase "roda o diagnóstico" | chat | GTIA/Meta | manual |
| Review Semanal Operacional | semanal | chat + formulário Worktesk | Worktesk | manual |
| Call de 15 dias | quinzenal | chat (prompt) | — | manual |

Tarefas agendadas locais do app desktop (Cowork) **não aparecem** daqui: só a `/varredura` no Mac encontra.

## Pontos de atenção
- Duas sincronizações da Meta em paralelo: `sync-meta-ads` (grava no `crm`) e `sync-meta-ops` (grava no `meta_ops`).
- Visões `central_*` do Commander não respeitam RLS (rodam como dono).
- Nenhuma migração registrada no Supabase: o histórico de mudanças do banco só existe nos chats.
