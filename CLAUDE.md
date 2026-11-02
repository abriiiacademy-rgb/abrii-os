# ABRii OS — cérebro do desenvolvimento

Este repositório é o ponto único de contexto de todas as ferramentas da ABRii.
Qualquer pessoa (Adrian, Railan) abre o Claude Code AQUI, em qualquer Mac.

## Ao começar qualquer sessão
1. Leia `ESTADO.md` → em que passo estamos e o que vem a seguir.
2. Leia `MAPA.md` → ferramentas, tabelas e conexões que já existem.
3. Leia `INVENTARIO.md` (gerado pela `/varredura`) para ver automações e chats de cada ferramenta.

## Regras
- Comando `/varredura`: levanta tudo o que existe. Rode antes de começar algo novo.
- Antes de criar qualquer coisa, confira no `MAPA.md` e no banco se já existe.
- Tudo é aditivo: não altere tabelas de outra ferramenta sem registrar aqui.
- Banco único: Supabase `huwlikdosgknyfoykjwn` (ABRii memória).
- Ferramenta Financeira e Worktesk estão fora deste banco — ainda não integradas.
- Apply está fora do escopo.

## Ao terminar qualquer sessão
- Atualize `ESTADO.md` (o que foi feito, passo atual, próximo passo).
- Se criou tabela, função ou conexão, atualize `MAPA.md`.
- Commit com mensagem clara.
