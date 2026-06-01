-- Execute este SQL no Supabase SQL Editor do seu projeto
-- https://supabase.com/dashboard/project/agcqafpfheycclmyhzkx/sql

-- Tabela de configurações do site (hero banner, etc.)
CREATE TABLE IF NOT EXISTS site_settings (
  key TEXT PRIMARY KEY,
  value TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

-- Qualquer usuário pode LER as configurações (necessário para o hero banner carregar)
CREATE POLICY "site_settings_read_all"
  ON site_settings FOR SELECT
  USING (true);

-- Apenas admins podem ESCREVER (via service role ou função admin)
-- Para funcionar com a chave anon do admin logado, use:
CREATE POLICY "site_settings_write_admin"
  ON site_settings FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Inserir valor padrão do hero banner
INSERT INTO site_settings (key, value)
VALUES ('hero_banner', '{"coverUrl":"","badge":"✦ Novo Lançamento Disponível","title1":"Assista os melhores","title2":"Filmes e Séries em HD","title3":"sem pagar nada","desc":"Acesse milhares de títulos, dos clássicos aos lançamentos mais recentes, com legendas em português e qualidade premium."}')
ON CONFLICT (key) DO NOTHING;
