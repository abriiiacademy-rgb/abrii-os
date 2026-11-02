# Onde estamos
_Atualizar ao fim de cada sessão._

## Passo atual: 2 — Varredura nos Macs

| # | Passo | Status |
|---|---|---|
| 1 | Mapear banco, conexões e automações visíveis (`MAPA.md`) | ✅ feito (02/11) |
| 2 | Rodar `/varredura` no Mac do Adrian e no do Railan → `INVENTARIO.md` | 🟡 Adrian feito (02/11); falta Railan |
| 3 | Confirmar o mapa: donos, Worktesk, Ferramenta Financeira, automações perdidas | ⏳ |
| 4 | Ligar os clientes (`migracoes/001_central.sql`) | ⏳ aguardando 2 respostas |
| 5 | Cadastro de cliente novo já nasce ligado | ⏳ |
| 6 | Commander e Jarvis leem a visão 360 | ⏳ |
| 7 | Integrar Worktesk e Ferramenta Financeira | ⏳ |

## Decisões tomadas
- 02/11 — Apply fora do escopo.
- 02/11 — Donos: Adrian = Commander e SGM; Railan = CRM (Adrian tem acesso).

## Decisões em aberto
- Fersary: "Alexandre Fersary" (GTIA) é o mesmo cliente que "Fersary imóveis"?
- Edmilson: "Edmilson Corretor" e "Edmilson - Corretor UNI" são um ou dois contratos?
- Quem é dono do GTIA, do Worktesk e do Portal?
- Onde está a automação dos contratos de fechamento da ABRimob?
- Religar ou apagar a tarefa "Gerar docs formulários ABRimob" (desligada desde 19/10)?
- Manter as sincronizações da Meta (3 caminhos) ou unificar? `sync-meta-ops` já está desligada desde 09/09: apagar?
- SGM: o `.env.local` aponta para o Supabase agwhfxdokegptwlzdnah, mas o schema `sgm` está no ABRii memória. Qual é o oficial? E o projeto `abrimob-central` (wjdqaexbjcpyptjcsxdd), o que é?
- Commander, SGM e Hub não têm git: criar repositórios no GitHub?
- Religar ou apagar as automações locais desligadas (WhatsApp do dia 8h40, avisos 8h15/16h45) e a tarefa "pendências GTIA"?
- Ferramenta Financeira está no Firebase: confirmar com Railan e onde fica o código.
- Worktesk tem Supabase próprio (yanvqenzhdzbuxrbeyit): migrar para o ABRii memória ou ligar por fora?
- Limpar `crm.meta_cron_log` (1,9 mi linhas)?

## Histórico
- 02/11 — `/varredura` no Mac do Adrian. **Novo:** Worktesk = Supabase yanvqenzhdzbuxrbeyit; Financeiro = Firebase; conexão CRM↔Commander existe no código (webhook "Ganhou" + cron sync); 20+ crons Vercel; 3 launchd e 1 tarefa agendada do Claude, todos desligados. **Mudou:** `sync-meta-ops` está desligada (mapa dizia ativa). **Sumiu/não achado:** tarefa "Gerar docs formulários ABRimob" e automação de contratos ABRimob não estão neste Mac. **Duplicado:** 3 caminhos de sync Meta; 3 cópias locais do GTIA (gtia-prosperity, gtia-CLIENTE antigas); 2 Commanders na Vercel (abrii-commander, abrimob-commander).
- 02/11 — Mapa do banco feito; migração 001 validada (28 clientes, 64/64 vínculos, sem Apply); comando `/varredura` criado.
