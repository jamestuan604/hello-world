FUNCTION getSuperSetChase(P_TOPTEAMID IN NUMBER, P_TEAMID IN NUMBER)
         RETURN NUMBER

IS

	topwins NUMBER(3);
	toplosses NUMBER(3);

	chaserwins NUMBER(3);
	chaserlosses NUMBER(3);

	gamesback number(5,2);

	 --Gets top team
	 CURSOR c_topteam IS
	 SELECT SUM(homelocationwin + awaylocationwin) wins, 
	        SUM(homelocationloss + awaylocationloss) losses
	 FROM stats
	 WHERE tmid = P_TOPTEAMID;

	 --Gets trailing team
	 CURSOR c_chaserteam IS
	 SELECT SUM(homelocationwin + awaylocationwin) wins, 
		SUM(homelocationloss + awaylocationloss) losses
	 FROM stats
         WHERE tmid = P_TEAMID;             

BEGIN

	--top team stats
	FOR topteam_rec in c_topteam
	LOOP
		topwins := nvl(topteam_rec.wins,0);
		toplosses := nvl(topteam_rec.losses,0);
	END LOOP;


	--trailer team stats
	FOR chaserteam_rec in c_chaserteam
	LOOP
		chaserwins := nvl(chaserteam_rec.wins,0);
		chaserlosses := nvl(chaserteam_rec.losses,0);
	END LOOP;

	gamesback := abs(((topwins - chaserwins) + (chaserlosses - toplosses)) / 2);

	RETURN gamesback;

EXCEPTION
	WHEN OTHERS THEN
	RAISE_APPLICATION_ERROR
	(-20102, 'Exception occurred in getSuperSetChase FUNCTION :'||SQLERRM || ': Top Team || P_TOPTEAMID || ' and Trailing Team || P_TEAMID);

END getSuperSetChase;

