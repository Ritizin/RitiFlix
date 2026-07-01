# RitiFlix — versão com URLs reais por aba

## O que mudou

Antes: **1 arquivo** `index.html` gigante (415 KB) com tudo dentro — CSS, JS e todas as
telas — e a navegação trocava de tela sem nunca mudar a URL.

Agora:
- **CSS** foi para `styles.css`
- **JS** foi para `app.js` (com um roteador novo, veja abaixo)
- Cada aba do menu virou uma **pasta de verdade** com seu próprio `index.html`,
  então a URL muda de verdade quando você navega — e também funciona se a
  pessoa colar o link direto ou der F5.

Todas as páginas carregam o **mesmo** `app.js` e `styles.css` (arquivo único,
compartilhado) — só o "molde" de HTML é repetido em cada pasta, que é como o
GitHub Pages consegue servir uma URL por pasta sem precisar de servidor.

## Estrutura de pastas / URLs geradas

```
RitiFlix/
├── index.html                       → /RitiFlix/                (Home)
├── styles.css
├── app.js
├── 404.html                         → cuida das rotas dinâmicas (veja abaixo)
├── explorar/index.html              → /RitiFlix/explorar/
├── filmes/index.html                → /RitiFlix/filmes/
├── series/index.html                → /RitiFlix/series/
├── lancamentos/index.html           → /RitiFlix/lancamentos/
├── animacao/index.html              → /RitiFlix/animacao/
├── acao/index.html                  → /RitiFlix/acao/
├── documentarios/index.html         → /RitiFlix/documentarios/
├── terror/index.html                → /RitiFlix/terror/
├── populares/index.html             → /RitiFlix/populares/
├── salas/index.html                 → /RitiFlix/salas/
├── perfil/index.html                → /RitiFlix/perfil/
├── perfil/favoritos/index.html      → /RitiFlix/perfil/favoritos/
├── perfil/historico/index.html      → /RitiFlix/perfil/historico/
├── perfil/configuracoes/index.html  → /RitiFlix/perfil/configuracoes/
├── admin/index.html                 → /RitiFlix/admin/                 (Dashboard)
├── admin/titulos/index.html         → /RitiFlix/admin/titulos/
├── admin/bot/index.html             → /RitiFlix/admin/bot/
├── admin/generos/index.html         → /RitiFlix/admin/generos/
├── admin/banners/index.html         → /RitiFlix/admin/banners/
├── admin/usuarios/index.html        → /RitiFlix/admin/usuarios/
├── admin/comentarios/index.html     → /RitiFlix/admin/comentarios/
├── admin/notificacoes/index.html    → /RitiFlix/admin/notificacoes/
└── admin/configuracoes/index.html   → /RitiFlix/admin/configuracoes/
```

Clicar em qualquer link do menu, perfil ou admin agora **atualiza a URL de
verdade** (via `history.pushState`), e o botão "voltar" do navegador funciona
normalmente.

## Rotas dinâmicas (título e player)

Página de um título específico e o player usam URLs tipo:
- `/RitiFlix/titulo/123` (detalhe do título)
- `/RitiFlix/assistir/123/4` (player)

Essas não dá pra pré-criar como pasta (teria que existir uma pasta pra cada
ID de título que já existe e que ainda vai existir). Pra elas funcionarem
mesmo com link direto/F5, incluí um `404.html` com o "truque" padrão de SPA
no GitHub Pages: se a URL não bate com nenhuma pasta física, ele redireciona
pro app preservando o caminho, e o `app.js` restaura a URL certinha.

**Detalhe importante:** ao abrir `/RitiFlix/assistir/...` direto (link
compartilhado ou F5), o app abre a **página do título** (não retoma o
episódio exato tocando sozinho), porque reconstruir o player exige recarregar
dados do banco primeiro. Navegando por dentro do site, o player normal
funciona 100% igual a antes.

## Como colocar no GitHub Pages

1. O nome do repositório precisa ser **RitiFlix** (é o que define a URL
   `Ritizin.github.io/RitiFlix`). Se o repositório tiver outro nome, veja a
   seção "Mudar o caminho base" abaixo.
2. Suba o **conteúdo da pasta `RitiFlix/`** (não a pasta em si) na raiz do
   repositório.
3. Não esqueça de colocar de volta os arquivos que já existiam no seu projeto
   e não estavam dentro do `index.html` original: `ritiflix.png`,
   `apple-touch-icon.png`, `site.webmanifest` e `sw.js` (se você usa) — eles
   continuam sendo referenciados, só que agora com caminho absoluto
   (`/RitiFlix/arquivo`), então funcionam em qualquer pasta.
4. Ative o GitHub Pages apontando pra branch/pasta onde esses arquivos estão.

## Mudar o caminho base (se o repo não se chamar "RitiFlix")

Em `app.js`, logo na primeira linha do roteador, tem:

```js
window.RITIFLIX_BASE = window.RITIFLIX_BASE || '/RitiFlix';
```

Troque `/RitiFlix` pelo nome real do seu repositório e também troque
`/RitiFlix` por `/SeuRepo` dentro do `404.html` (variável `base`). Fora isso,
não precisa mexer em mais nada.

## Por que ficou "mais otimizado"

- CSS e JS deixaram de ser copiados 24 vezes — agora são **um arquivo só**,
  carregado (e cacheado pelo navegador) uma única vez pra todas as páginas.
- Só o HTML "molde" (menu, modais, containers das telas) se repete em cada
  pasta — é o preço de ter URL de verdade em hospedagem estática sem
  servidor, mas ainda assim é bem mais leve do que replicar o arquivo de
  415 KB inteiro 24 vezes.
