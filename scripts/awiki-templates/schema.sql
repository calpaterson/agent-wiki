CREATE TABLE IF NOT EXISTS wiki_meta (
    path TEXT PRIMARY KEY,
    mtime REAL NOT NULL,
    summary TEXT DEFAULT '',
    vec_rowid INTEGER
);

CREATE VIRTUAL TABLE IF NOT EXISTS wiki_vec USING vec0(
    embedding float[768] distance_metric=cosine
);

CREATE VIRTUAL TABLE IF NOT EXISTS wiki_fts USING fts5(path, body, tokenize='porter');
