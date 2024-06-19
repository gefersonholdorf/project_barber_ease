USE teste01_barbearia;

CREATE OR REPLACE VIEW `v_numero_total_cliente` AS
	SELECT COUNT(*) AS quantidade_clientes
    FROM usuario AS u
    INNER JOIN cliente AS c ON u.id = c.usuario_id;
    
SELECT * FROM v_numero_total_cliente;

CREATE OR REPLACE VIEW `v_numero_clientes_ativos` AS
	SELECT COUNT(DISTINCT c.id) AS cliente_ativos
    FROM usuario AS u
    INNER JOIN cliente AS c ON u.id = c.usuario_id
    LEFT JOIN agendamento AS a ON c.id = a.cliente_id
    WHERE c.is_ativo LIKE 'ATIVO' AND EXTRACT(MONTH FROM a.data_hora) >= EXTRACT(MONTH FROM CURRENT_DATE);
    
SELECT * FROM v_numero_clientes_ativos;

DELIMITER $
CREATE PROCEDURE `usp_novos_clientes_cadastrados_mes`(p_mes INT)
BEGIN

	SELECT COUNT(*) AS contagem_mes
	FROM usuario AS u
    INNER JOIN cliente AS c ON u.id = c.usuario_id
    WHERE EXTRACT(MONTH FROM u.data_criacao) = p_mes;

END $
DELIMITER ;

CALL usp_novos_clientes_cadastrados_mes(6);

CREATE VIEW `v_taxa_cliente_cancelaram_agendamentos` AS
	SELECT ROUND(((COUNT(*) / (SELECT COUNT(*) FROM usuario AS u INNER JOIN cliente AS c ON u.id = c.usuario_id)) * 100), 2) AS taxa_cancelamento
    FROM agendamento
    WHERE status LIKE '%CANCELADO%';
    
SELECT * FROM v_taxa_cliente_cancelaram_agendamentos;