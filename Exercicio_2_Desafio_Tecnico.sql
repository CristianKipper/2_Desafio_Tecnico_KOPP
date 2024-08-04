-- Criando tabela de Remessas.
CREATE TABLE remessas (
    id SERIAL PRIMARY KEY,
    total_infracoes INTEGER NOT NULL,
    situacao VARCHAR(20) CHECK (situacao IN ('Criada', 'Expedida', 'Aceita', 'Não Aceita'))
);

-- Criando tabela de Infrações.
CREATE TABLE infrações (
    id SERIAL PRIMARY KEY,
    numero INTEGER NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    equipamento VARCHAR(50) NOT NULL,
    velocidade_permitida INTEGER NOT NULL,
    velocidade_medida INTEGER NOT NULL,
    validade BOOLEAN NOT NULL,
    remessa_id INTEGER REFERENCES remessas(id) ON DELETE CASCADE
);

-- Inserindo dados na tabela Remessas.
insert into remessas(total_infracoes, situacao) values 
(5, 'Criada'),
(5, 'Expedida'),
(5, 'Aceita'),
(5, 'Não Aceita');


-- Inserindo dados na tabela Infrações.
insert into infrações(numero,data_hora,equipamento,velocidade_permitida,velocidade_medida,validade,remessa_id) values 
(001, '2024-08-01 14:30:00', 'G11011', 60, 54, FALSE, 1),
(002, '2024-08-02 15:45:00', 'G11012', 60, 55,TRUE, 2),
(003, '2024-08-03 16:00:00', 'G11013', 60, 70, FALSE, 3),
(004, '2024-08-04 17:30:00', 'G11014', 60, 80, TRUE, 4),
(005, '2024-08-05 18:15:00', 'G11015', 60, 72, TRUE, 1),
(006, '2024-08-06 19:00:00', 'G11016', 40, 50, TRUE, 2),
(007, '2024-08-07 20:30:00', 'G11017', 40, 67, FALSE, 3),
(008, '2024-08-08 21:45:00', 'G11018', 40, 34, TRUE, 4),
(009, '2024-08-09 22:00:00', 'G11019', 40, 41, TRUE, 1),
(010, '2024-08-10 23:30:00', 'G11020', 40, 70, FALSE, 2),
(011, '2024-08-11 12:00:00', 'G11021', 80, 88, TRUE, 3),
(012, '2024-08-12 13:15:00', 'G11022', 80, 85, FALSE, 4),
(013, '2024-08-13 14:00:00', 'G11023', 80, 120, TRUE, 1),
(014, '2024-08-14 15:30:00', 'G11024', 80, 77, TRUE, 2),
(015, '2024-08-15 16:45:00', 'G11025', 80, 100, TRUE, 3),
(016, '2024-08-16 17:00:00', 'G11026', 100, 121, FALSE, 4),
(017, '2024-08-17 18:30:00', 'G11027', 100, 95, FALSE, 1),
(018, '2024-08-18 19:45:00', 'G11028', 100, 84, FALSE, 2),
(019, '2024-08-19 20:00:00', 'G11029', 100, 97, TRUE, 3),
(020, '2024-08-20 21:30:00', 'G11030', 100, 150, TRUE, 4);

-- Selecionando todos os dados da tabela Remessas.
SELECT * FROM remessas;

-- Selecionando todos os dados da tabela Infrações.
SELECT * FROM infrações;

-- Selecionando todas as infrações com velocidade medida igual ou acima de 20% da velocidade permitida e ordenando a lista por data e hora da infração.
SELECT i.id, i.numero, i.data_hora, i.equipamento, i.velocidade_permitida, i.velocidade_medida, i.validade,
	r.id AS remessa_id,r.situacao FROM infrações i JOIN remessas r ON i.remessa_id = r.id WHERE
    i.velocidade_medida >= i.velocidade_permitida * 1.20 ORDER BY i.data_hora;

-- Selecionando todas as Remessas buscando por sua identificação, sua situação, o total de infrações, total de infrações válidas e total de infrações inválidas e ordenar a consulta pela situação das remessas.
SELECT r.id AS remessa_id, r.situacao, COUNT(i.id) AS total_infracoes,
    SUM(CASE WHEN i.validade = TRUE THEN 1 ELSE 0 END) AS total_validas,
    SUM(CASE WHEN i.validade = FALSE THEN 1 ELSE 0 END) AS total_invalidas
	FROM remessas r LEFT JOIN infrações i ON r.id = i.remessa_id GROUP BY r.id, r.situacao ORDER BY r.situacao;