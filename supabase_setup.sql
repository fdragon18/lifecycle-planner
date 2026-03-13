-- 検索履歴テーブル
CREATE TABLE searches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT,
  birth_year INT NOT NULL,
  birth_month INT NOT NULL,
  birth_day INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS有効化
ALTER TABLE searches ENABLE ROW LEVEL SECURITY;

-- 自分のデータだけ見れるポリシー
CREATE POLICY "Users can view own searches"
ON searches FOR SELECT
USING (auth.uid() = user_id);

-- 自分のデータだけ追加できるポリシー
CREATE POLICY "Users can insert own searches"
ON searches FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 自分のデータだけ削除できるポリシー
CREATE POLICY "Users can delete own searches"
ON searches FOR DELETE
USING (auth.uid() = user_id);
