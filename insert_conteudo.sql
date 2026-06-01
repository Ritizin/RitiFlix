-- ============================================================
-- SCRIPT DE INSERÇÃO DE FILMES E SÉRIES - RitiFlix
-- Execute no Supabase SQL Editor:
-- https://supabase.com/dashboard/project/agcqafpfheycclmyhzkx/sql
-- ============================================================

-- Garante que a tabela animes existe (estrutura básica)
CREATE TABLE IF NOT EXISTS animes (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  emoji TEXT DEFAULT '🎬',
  poster TEXT,
  description TEXT,
  genres TEXT[],
  status TEXT DEFAULT 'Completo',
  episodes INTEGER DEFAULT 1,
  year INTEGER DEFAULT 2024,
  score NUMERIC(3,1) DEFAULT 8.0,
  featured BOOLEAN DEFAULT FALSE,
  is_new BOOLEAN DEFAULT FALSE,
  popular BOOLEAN DEFAULT FALSE,
  type TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- FILMES
-- ============================================================
INSERT INTO animes (title, emoji, poster, description, genres, status, episodes, year, score, featured, is_new, popular) VALUES

('Oppenheimer', '💥', 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
 'A história do físico americano J. Robert Oppenheimer e seu papel crucial no Projeto Manhattan, que desenvolveu a primeira bomba atômica durante a Segunda Guerra Mundial.',
 ARRAY['Filme', 'Drama', 'História', 'Biografia'], 'Completo', 1, 2023, 8.5, TRUE, FALSE, TRUE),

('Duna: Parte Dois', '🏜️', 'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg',
 'Paul Atreides une forças com Chani e os Fremen enquanto busca vingança contra os conspiradores que destruíram sua família.',
 ARRAY['Filme', 'Ficção Científica', 'Aventura', 'Ação'], 'Completo', 1, 2024, 8.7, TRUE, TRUE, TRUE),

('Deadpool & Wolverine', '🦸', 'https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg',
 'Deadpool é recrutado pela TVA e precisa da ajuda de Wolverine para salvar seu universo. A dupla improvável enfrenta ameaças que eles não esperavam.',
 ARRAY['Filme', 'Ação', 'Comédia', 'Super-heróis'], 'Completo', 1, 2024, 8.1, TRUE, TRUE, TRUE),

('Alien: Romulus', '👾', 'https://image.tmdb.org/t/p/w500/b33nnKl1GSFbao4l3fZDDqsMx0F.jpg',
 'Um grupo de jovens colonizadores do espaço se depara com a forma de vida mais aterrorizante do universo enquanto vasculha uma estação espacial abandonada.',
 ARRAY['Filme', 'Terror', 'Ficção Científica', 'Ação'], 'Completo', 1, 2024, 7.3, FALSE, TRUE, TRUE),

('Kung Fu Panda 4', '🐼', 'https://image.tmdb.org/t/p/w500/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg',
 'Po é escolhido como o novo Líder Espiritual do Vale da Paz, mas primeiro deve treinar um novo Guerreiro Dragão.',
 ARRAY['Filme', 'Animação', 'Aventura', 'Família', 'Comédia'], 'Completo', 1, 2024, 7.1, FALSE, TRUE, FALSE),

('Inside Out 2', '🧠', 'https://image.tmdb.org/t/p/w500/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg',
 'Riley entra na adolescência e novas emoções chegam ao quartel-general — Ansiedade, Inveja, Tédio e Vergonha — gerando conflito com as emoções originais.',
 ARRAY['Filme', 'Animação', 'Família', 'Drama', 'Comédia'], 'Completo', 1, 2024, 7.8, TRUE, FALSE, TRUE),

('Coringa: Delírio a Dois', '🃏', 'https://image.tmdb.org/t/p/w500/coDfuchesna4kCYwet6yEMjCGgL.jpg',
 'Arthur Fleck está confinado na Arkham à espera de julgamento por seus crimes como Coringa. Lá ele encontra o grande amor de sua vida.',
 ARRAY['Filme', 'Drama', 'Crime', 'Musical'], 'Completo', 1, 2024, 5.5, FALSE, TRUE, FALSE),

('Godzilla e Kong: O Novo Império', '🦖', 'https://image.tmdb.org/t/p/w500/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg',
 'Godzilla e Kong unem forças para enfrentar uma ameaça colossal escondida no nosso mundo, desafiando sua própria existência e a de toda a humanidade.',
 ARRAY['Filme', 'Ação', 'Ficção Científica', 'Aventura'], 'Completo', 1, 2024, 6.3, FALSE, FALSE, TRUE),

('Civil War', '📸', 'https://image.tmdb.org/t/p/w500/sh7Rg8Er3tFcN9BpKIPOMvALgZd.jpg',
 'Uma equipe de jornalistas atravessa os Estados Unidos enquanto forças separatistas marcham em direção a Washington D.C.',
 ARRAY['Filme', 'Ação', 'Drama', 'Thriller'], 'Completo', 1, 2024, 7.1, FALSE, TRUE, FALSE),

('O Menino e a Garça', '🐦', 'https://image.tmdb.org/t/p/w500/f9qa2XDDR0bOq3HLRnPGJRPvpN0.jpg',
 'Após a morte de sua mãe, Mahito se muda para o campo com seu pai e sua madrasta, onde encontra uma garça cinza-azulada que o guia para um mundo fantástico.',
 ARRAY['Filme', 'Animação', 'Fantasia', 'Aventura'], 'Completo', 1, 2023, 7.8, TRUE, FALSE, TRUE),

('Pobres Criaturas', '🌸', 'https://image.tmdb.org/t/p/w500/kCGlIMHnOm8JPXIf6w0JNVVAKXe.jpg',
 'Bella Baxter é trazida de volta à vida pelo brilhante e pouco ortodoxo cientista Dr. Godwin Baxter. Curiosa para experimentar o mundo, ela foge com o advogado Duncan Wedderburn.',
 ARRAY['Filme', 'Drama', 'Fantasia', 'Romance'], 'Completo', 1, 2023, 7.8, FALSE, FALSE, TRUE),

('Missão: Impossível – Acerto de Contas Parte 1', '🕵️', 'https://image.tmdb.org/t/p/w500/NNxYkU70HPurnNCSiCjfoLEx.jpg',
 'Ethan Hunt e a equipe do IMF embarcam na missão mais perigosa até agora: rastrear uma terrível arma nova antes que ela caia em mãos erradas.',
 ARRAY['Filme', 'Ação', 'Aventura', 'Espionagem'], 'Completo', 1, 2023, 7.7, FALSE, FALSE, FALSE),

('Interestelar', '🚀', 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
 'Uma equipe de exploradores viaja através de um buraco de minhoca no espaço numa tentativa de garantir a sobrevivência da humanidade.',
 ARRAY['Filme', 'Ficção Científica', 'Drama', 'Aventura'], 'Completo', 1, 2014, 8.7, TRUE, FALSE, TRUE),

('Clube da Luta', '🥊', 'https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg',
 'Um homem insatisfeito com sua vida forma um clube de luta clandestino com um vendedor de sabão carismático.',
 ARRAY['Filme', 'Drama', 'Thriller', 'Ação'], 'Completo', 1, 1999, 8.8, FALSE, FALSE, TRUE),

('Parasita', '🏠', 'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
 'A família Kim, todos desempregados, se infiltra na abastada família Park de forma sorrateira, começando com o filho mais velho, que se torna professor de inglês.',
 ARRAY['Filme', 'Drama', 'Thriller', 'Comédia'], 'Completo', 1, 2019, 8.5, FALSE, FALSE, TRUE);

-- ============================================================
-- SÉRIES
-- ============================================================
INSERT INTO animes (title, emoji, poster, description, genres, status, episodes, year, score, featured, is_new, popular) VALUES

('The Last of Us', '🍄', 'https://image.tmdb.org/t/p/w500/uKvVjHNqB5VmOrdxqAt2F7J78ED.jpg',
 'Joel, um sobrevivente endurecido, é contratado para contrabandear Ellie, uma garota de 14 anos, para fora de uma zona de quarentena. O que começa como um trabalho se torna uma jornada brutal.',
 ARRAY['Série', 'Drama', 'Terror', 'Ficção Científica'], 'Em andamento', 17, 2023, 8.7, TRUE, FALSE, TRUE),

('House of the Dragon', '🐉', 'https://image.tmdb.org/t/p/w500/z2yahl2uefxDCl0nogcRBstwruJ.jpg',
 'A história da Casa Targaryen, ambientada 200 anos antes dos eventos de Game of Thrones. Uma guerra civil que devastou a família real.',
 ARRAY['Série', 'Fantasia', 'Drama', 'Aventura'], 'Em andamento', 18, 2022, 8.4, TRUE, FALSE, TRUE),

('Stranger Things', '🔦', 'https://image.tmdb.org/t/p/w500/x2LSRK2Cm7MZhjluni1msVJ3wDj.jpg',
 'Quando um garoto desaparece, uma cidade pequena descobre um mistério envolvendo experimentos secretos, forças sobrenaturais aterrorizantes e uma garota muito estranha.',
 ARRAY['Série', 'Ficção Científica', 'Terror', 'Drama'], 'Em andamento', 42, 2016, 8.7, TRUE, FALSE, TRUE),

('Breaking Bad', '⚗️', 'https://image.tmdb.org/t/p/w500/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
 'Walter White, professor de química com câncer, começa a fabricar metanfetamina com seu ex-aluno para garantir o futuro financeiro de sua família.',
 ARRAY['Série', 'Drama', 'Crime', 'Thriller'], 'Completo', 62, 2008, 9.5, TRUE, FALSE, TRUE),

('The Bear', '🍽️', 'https://image.tmdb.org/t/p/w500/sHFlbKS3WLqMnp9t2ghADIJFnuQ.jpg',
 'Um chef de renome mundial retorna para Chicago para administrar o sanduíche de carne de sua família depois da morte de seu irmão.',
 ARRAY['Série', 'Drama', 'Comédia'], 'Em andamento', 28, 2022, 8.7, FALSE, TRUE, TRUE),

('Shogun', '⛩️', 'https://image.tmdb.org/t/p/w500/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg',
 'No Japão feudal de 1600, um navegador inglês chega ao país como piloto de um navio holandês e se envolve nas lutas pelo poder entre os senhores japoneses.',
 ARRAY['Série', 'Drama', 'Ação', 'História'], 'Completo', 10, 2024, 8.7, FALSE, TRUE, TRUE),

('Severance', '🧬', 'https://image.tmdb.org/t/p/w500/jnFMHb5rFMkAlmCJV3ZGxFYV6iE.jpg',
 'Mark lidera uma equipe de trabalhadores que concordaram em separar cirurgicamente suas memórias profissionais e pessoais — uma decisão que logo vai se revelar mais sinistra do que parecia.',
 ARRAY['Série', 'Drama', 'Ficção Científica', 'Mistério'], 'Em andamento', 19, 2022, 8.7, FALSE, FALSE, TRUE),

('The Boys', '💥', 'https://image.tmdb.org/t/p/w500/stTEycfG9928HYGEISKAngSkInP.jpg',
 'Num mundo onde super-heróis são celebridades corruptas, um grupo de vigilantes conhecidos como "The Boys" se propõe a acabar com o abuso de poder desses super-humanos.',
 ARRAY['Série', 'Ação', 'Ficção Científica', 'Comédia'], 'Em andamento', 32, 2019, 8.7, FALSE, FALSE, TRUE),

('Succession', '💼', 'https://image.tmdb.org/t/p/w500/e2X8g0KO0p3jWLfmBFBXaZNRuq2.jpg',
 'A família Roy, que controla um dos maiores conglomerados de mídia e entretenimento do mundo, entra em guerra quando o pai começa a pensar na aposentadoria.',
 ARRAY['Série', 'Drama', 'Comédia'], 'Completo', 39, 2018, 8.9, FALSE, FALSE, TRUE),

('Arcane', '⚡', 'https://image.tmdb.org/t/p/w500/fqldf2t8ztc9aiwn3k6mlX3tvRT.jpg',
 'Baseado no mundo de League of Legends, Arcane explora a rivalidade entre as regiões Piltover e Zaun, seguindo irmãs de lados opostos de um conflito crescente.',
 ARRAY['Série', 'Animação', 'Fantasia', 'Ação'], 'Em andamento', 18, 2021, 9.0, TRUE, TRUE, TRUE),

('The Witcher', '⚔️', 'https://image.tmdb.org/t/p/w500/cZ0d3rtvXPVvuiX22sP79K3Hmjz.jpg',
 'Geralt de Rívia, um caçador mutante de monstros, luta para encontrar seu lugar em um mundo onde as pessoas muitas vezes provam ser mais malignas que as bestas.',
 ARRAY['Série', 'Fantasia', 'Drama', 'Ação'], 'Em andamento', 24, 2019, 8.2, FALSE, FALSE, TRUE),

('Wednesday', '🖤', 'https://image.tmdb.org/t/p/w500/jeGtaMwGxPmQN5xM4ClnwPQcNQy.jpg',
 'Wednesday Addams é matriculada na Academia Nevermore, onde ela tenta dominar suas habilidades psíquicas emergentes, frustrar uma onda de assassinatos e desvendar o mistério sobrenatural que envolveu seus pais.',
 ARRAY['Série', 'Terror', 'Comédia', 'Mistério'], 'Em andamento', 16, 2022, 8.1, FALSE, TRUE, TRUE),

('Loki', '🐍', 'https://image.tmdb.org/t/p/w500/kEl2t3OhXc3Zb9FBh1AuYzRTgZp.jpg',
 'Depois de roubar o Tesseract, a variante de Loki é capturada pela AVT e forçada a ajudá-la a investigar outra variante ainda mais perigosa.',
 ARRAY['Série', 'Ação', 'Aventura', 'Ficção Científica'], 'Completo', 12, 2021, 8.2, FALSE, FALSE, FALSE);

-- ============================================================
-- Confirmar inserção
-- ============================================================
SELECT COUNT(*) as total_titulos, 
       SUM(CASE WHEN 'Filme' = ANY(genres) THEN 1 ELSE 0 END) as filmes,
       SUM(CASE WHEN 'Série' = ANY(genres) THEN 1 ELSE 0 END) as series
FROM animes;
