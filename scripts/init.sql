-- Configuração para CDC com Debezium
ALTER SYSTEM SET wal_level = 'logical';

-- Criar tabelas
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    balance DECIMAL(15, 2)
);

CREATE TABLE IF NOT EXISTS cards (
    card_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    card_number VARCHAR(16)
);

CREATE TABLE IF NOT EXISTS merchants (
    merchant_id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id SERIAL PRIMARY KEY,
    card_id INT REFERENCES cards(card_id),
    merchant_id INT REFERENCES merchants(merchant_id),
    amount DECIMAL(15, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Habilitar REPLICA IDENTITY FULL para capturar 'before' nos UPDATEs (exigência do CDC)
ALTER TABLE customers REPLICA IDENTITY FULL;
ALTER TABLE accounts REPLICA IDENTITY FULL;
ALTER TABLE cards REPLICA IDENTITY FULL;
ALTER TABLE merchants REPLICA IDENTITY FULL;
ALTER TABLE transactions REPLICA IDENTITY FULL;

-- Carga inicial de dados (Seed)
INSERT INTO customers (name, email) VALUES ('Cliente Teste 1', 'teste1@exemplo.com'), ('Cliente Teste 2', 'teste2@exemplo.com');
INSERT INTO accounts (customer_id, balance) VALUES (1, 5000.00), (2, 10000.00);
INSERT INTO cards (account_id, card_number) VALUES (1, '1234567812345678'), (2, '8765432187654321');
INSERT INTO merchants (name) VALUES ('Loja A'), ('Loja B');