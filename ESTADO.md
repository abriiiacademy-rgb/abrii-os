# Onde estamos
_Atualizar ao fim de cada sessão._

## Passo atual: 3 — Confirmar o mapa

| # | Passo | Status |
|---|---|---|
| 1 | Mapear banco, conexões e automações visíveis (`MAPA.md`) | ✅ feito (02/11) |
| 2 | Rodar `/varredura` no Mac do Adrian e no do Railan → `INVENTARIO.md` | ✅ Adrian 02/11, Railan 03/11 |
| 3 | Confirmar o mapa: donos, Worktesk, Ferramenta Financeira, automações perdidas | 🟡 Worktesk e Financeiro confirmados (Railan); faltam donos de GTIA, Portal e automação de contratos ABRimob |
| 4 | Ligar os clientes (`migracoes/001_central.sql`) | ⏳ aguardando 2 respostas |
| 5 | Cadastro de cliente novo já nasce ligado | ⏳ |
| 6 | Commander e Jarvis leem a visão 360 | ⏳ |
| 7 | Integrar Worktesk e Ferramenta Financeira | ⏳ |

## Decisões tomadas
- 02/11 — Commander, SGM e Hub ganham repositórios privados no GitHub; regra: `.gitignore` com `.env*`, `node_modules`, `.vercel` antes do primeiro commit.
- 02/11 — Apply fora do escopo.
- 02/11 — Donos: Adrian = Commander e SGM; Railan = CRM (Adrian tem acesso).
- 03/11 — Donos confirmados: Railan = Worktesk + Ferramenta Financeira (dashboard + webhook Asaas). Firebase confirmado como banco do Financeiro.

## Decisões em aberto
- Fersary: "Alexandre Fersary" (GTIA) é o mesmo cliente que "Fersary imóveis"?
- Edmilson: "Edmilson Corretor" e "Edmilson - Corretor UNI" são um ou dois contratos?
- Quem é dono do GTIA e do Portal? (Worktesk = Railan, confirmado 03/11)
- Onde está a automação dos contratos de fechamento da ABRimob?
- Religar ou apagar a tarefa "Gerar docs formulários ABRimob" (desligada desde 19/10)?
- Manter as sincronizações da Meta (3 caminhos) ou unificar? `sync-meta-ops` já está desligada desde 09/09: apagar?
- SGM: o `.env.local` aponta para o Supabase agwhfxdokegptwlzdnah, mas o schema `sgm` está no ABRii memória. Qual é o oficial? E o projeto `abrimob-central` (wjdqaexbjcpyptjcsxdd), o que é?
- Religar ou apagar as automações locais desligadas (WhatsApp do dia 8h40, avisos 8h15/16h45) e a tarefa "pendências GTIA"?
- Ferramenta Financeira = Firebase confirmado. Código: `~/Desktop/claude code/abrii-dashboard` (railanjunior/abrii-dashboard, HTML/GitHub Pages) + `~/Desktop/claude code/abrii-asaas-webhook` (abriiiacademy-rgb/abrii-asaas-webhook, Vercel). Falta: mover `abrii-dashboard` para a org `abriiiacademy-rgb`?
- Worktesk tem Supabase próprio (yanvqenzhdzbuxrbeyit): migrar para o ABRii memória ou ligar por fora?
- Limpar `crm.meta_cron_log` (1,9 mi linhas)?
- Mover `railanjunior/abrii-worktesk` e `railanjunior/abrii-dashboard` para a org `abriiiacademy-rgb` (unificar ownership)?
- Arquivar ou retomar `abrii-adops` (MCP próprio de Meta Ads, parado desde 10/08)?
- Revogar as chaves Binance expostas em `~/Desktop/jarvis.py` (projeto abandonado) e apagar o arquivo.
- Apagar as 2 tarefas agendadas órfãs do Claude Code no Mac do Railan (`asaas-chat-humano`, `valida-badge-verde-facebook-ads`).
- `abrii-dashboard` publica no GitHub Pages E existe `abrii-financeiro` como projeto Vercel: é o mesmo site em 2 deploys ou são coisas diferentes?
- Railan nunca puxa `abrii-crm` local (3 meses atrás do GitHub): como ele está editando o CRM na prática? (direto na nuvem via Cursor/Chrome?)

## Histórico
- 02/11 — Criados os repositórios privados `abrii-commander` (386fc83), `sgm-abrimob` (1d4c434) e `abrii-hub` (039df72). Conferido no GitHub: privados e sem `.env`/`node_modules`/`.vercel`/`.next`. Descoberto que o Commander é um código só com duas instâncias na Vercel (abrii e abrimob), o que não é duplicação.
- 02/11 — `/varredura` no Mac do Adrian. **Novo:** Worktesk = Supabase yanvqenzhdzbuxrbeyit; Financeiro = Firebase; conexão CRM↔Commander existe no código (webhook "Ganhou" + cron sync); 20+ crons Vercel; 3 launchd e 1 tarefa agendada do Claude, todos desligados. **Mudou:** `sync-meta-ops` está desligada (mapa dizia ativa). **Sumiu/não achado:** tarefa "Gerar docs formulários ABRimob" e automação de contratos ABRimob não estão neste Mac. **Duplicado:** 3 caminhos de sync Meta; 3 cópias locais do GTIA (gtia-prosperity, gtia-CLIENTE antigas); 2 Commanders na Vercel (abrii-commander, abrimob-commander).
- 02/11 — Mapa do banco feito; migração 001 validada (28 clientes, 64/64 vínculos, sem Apply); comando `/varredura` criado.
- 03/11 — `/varredura` no Mac do Railan. **Novo:** Firebase confirmado como banco do Financeiro; GH Actions `daily-trigger.yml` como backup dos crons Vercel das 3 dailies (Worktesk, Couto, Star); cron `/api/saldo` do webhook Asaas; 2 tarefas agendadas órfãs do Claude Code; skill global `checkup` (DISC via Instagram). **Mudou:** Worktesk está em `railanjunior/abrii-worktesk` (pessoal), **não** em `abriiiacademy-rgb/abrii-worktesk` como o mapa dizia — essa org não tem o repo. **Sumiu/não achado:** Commander/SGM/GTIA/Hub não estão no Mac do Railan (esperado). **Duplicado:** nome local da pasta do CRM diverge (Adrian = `abrii-lead-crm`, Railan = `abrii-crm`, mesmo repo); dashboard financeiro tem 2 deploys (GitHub Pages + `abrii-financeiro` Vercel). **Divergente:** CRM local do Railan está 3 meses atrás do GitHub (vs 1 mês atrás no Mac do Adrian) — nenhum dos 2 Macs tem a versão de produção.
