---
description: Varre tudo o que existe (ferramentas, conexões, automações, chats) e atualiza INVENTARIO.md, MAPA.md e ESTADO.md
---

# /varredura — inventário completo do ABRii OS

Objetivo: descobrir TUDO o que já existe antes de criar qualquer coisa.
Só leitura. Não altere nada fora deste repositório. Nunca copie senhas, tokens ou chaves:
registre só o NOME da variável ou credencial.

Quem roda: Adrian (Commander, SGM, GTIA) e Railan (CRM, Ferramenta Financeira), cada um no seu Mac.
Escopo: Commander, SGM, GTIA/Jarvis, CRM (ABRiilead), Worktesk, Ferramenta Financeira, Portal.
Fora do escopo: Apply.

## 1. Banco (Supabase "ABRii memória", projeto huwlikdosgknyfoykjwn)
Use o MCP do Supabase, ou `psql` se houver acesso. Levante:
- Schemas e tabelas com contagem de linhas
- Chaves estrangeiras e funções que cruzam schemas (conexões entre ferramentas)
- Triggers
- `cron.job` (agendamentos do banco)
- Edge Functions
- `meta_ops.agendamentos` (rotinas agendadas do GTIA: Daily, relatórios)
- `public.tools` e `public.tool_access` (portal de login)
Se o Railan tiver outro projeto Supabase (Ferramenta Financeira, Worktesk), repita nele.

## 2. Este Mac
- `~/.claude/projects/` → cada pasta é um projeto com chats do Claude Code (.jsonl).
  Diga a qual ferramenta cada pasta pertence, a data da última sessão e o que foi feito por último.
- `~/.claude/commands/`, `~/.claude/skills/`, `~/.claude/agents/` → comandos, skills e agentes criados.
- `~/.claude/settings.json` e `.mcp.json` dos projetos → MCPs conectados (só nomes).
- `crontab -l` e `launchctl list | grep -v com.apple` → automações locais.
- Pastas de código das ferramentas: localize por `package.json`, `vercel.json`, `supabase/`.
  Para cada uma: nome, caminho, repositório git (`git remote -v`), último commit,
  crons do Vercel (`vercel.json`), variáveis de ambiente usadas (só nomes).
- Se `gh` e `vercel` estiverem logados: `gh repo list` e `vercel project ls`.

## 3. Automações e rotinas (o ponto mais esquecido)
Monte uma tabela única com TODA automação ou rotina encontrada:

| Nome | O que faz | Gatilho (horário, evento ou frase no chat) | Onde roda | Ferramenta | Dono | Status |

Procure em: cron do banco, Edge Functions, agendamentos do GTIA, crons do Vercel,
crontab/launchd, tarefas agendadas do Claude, e chats que definem gatilhos
("Pode rodar o Daily", "roda o diagnóstico", review semanal do Worktesk etc.).
Marque como "manual" o que depende de alguém pedir no chat.

## 4. Saída
1. Escreva `INVENTARIO.md` (seções: Ferramentas, Conexões, Automações, Chats de desenvolvimento,
   MCPs, Lacunas). Se já existir, ATUALIZE a seção da sua máquina sem apagar a do outro sócio.
2. Atualize `MAPA.md` se algo novo apareceu ou se algo do mapa não existe mais.
3. Atualize `ESTADO.md`: marque o passo, registre o que mudou e liste as dúvidas.
4. Compare com a varredura anterior e liste: o que é novo, o que sumiu, o que está duplicado.
5. Commit: "varredura <data> — <máquina>".
