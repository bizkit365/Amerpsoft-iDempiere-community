﻿-- Function: adempiere.amf_acctper0prevbalance(numeric, numeric, numeric, numeric)

DROP FUNCTION adempiere.amf_acctper0prevbalance(numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION adempiere.amf_acctper0prevbalance(p_client_id numeric, p_org_id numeric, p_account_id numeric, p_period_id numeric)
  RETURNS numeric AS
$BODY$
DECLARE
	v_acctprevbalance	numeric :=0;
	v_acctdebperiod	numeric :=0;
	v_acctcreperiod	numeric :=0;
BEGIN
		v_acctprevbalance := 0;
	    IF (p_org_id > 0) THEN
			select 
				coalesce(sum(fas.amtacctdr),0.00),coalesce(sum(fas.amtacctcr),0.00)  INTO v_acctdebperiod,v_acctcreperiod
			FROM
				adempiere.fact_acct as fas
			WHERE
				fas.ad_client_id=p_client_id and fas.ad_org_id=p_org_id and fas.account_id = p_account_id and fas.dateacct < amf_periodstartdate( p_period_id )
			;
		ELSE
			select 
				coalesce(sum(fas.amtacctdr),0.00),coalesce(sum(fas.amtacctcr),0.00)  INTO v_acctdebperiod,v_acctcreperiod
			FROM
				adempiere.fact_acct as fas
			WHERE
				fas.ad_client_id=p_client_id  and fas.account_id = p_account_id and fas.dateacct < amf_periodstartdate( p_period_id )
			;
	    END IF;
		v_acctprevbalance := v_acctdebperiod-v_acctcreperiod;
    	RETURN  v_acctprevbalance;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION adempiere.amf_acctper0prevbalance(numeric, numeric, numeric, numeric)
  OWNER TO adempiere;
