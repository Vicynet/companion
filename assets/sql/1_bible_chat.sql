-- Create the session table
CREATE TABLE session (
    sessionId TEXT PRIMARY KEY,
    conversationId TEXT UNIQUE,
    title TEXT,
    book VARCHAR(20),
    chapter INTEGER,
    verse INTEGER,
    translation TEXT,
    language TEXT,
    timestamp DATETIME
);

-- Create the conversation table
CREATE TABLE conversation (
    id INTEGER PRIMARY KEY,
    conversationId TEXT,
    role VARCHAR(50),
    message TEXT,
    timestamp DATETIME,
    FOREIGN KEY (conversationId) REFERENCES session(conversationId)
);
