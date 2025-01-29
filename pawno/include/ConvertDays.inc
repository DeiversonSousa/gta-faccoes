#define ConvertDays(%0) (gettime() + (86400 * (%0)))

stock VerifyExpiredDays(days)
	return (days) < gettime();

stock ConvertToDays(n)
{
	new t[5], String[75];
	t[4] = n-gettime();
	t[0] = t[4] / 3600;
	t[1] = ((t[4] / 60) - (t[0] * 60));
	t[2] = (t[4] - ((t[0] * 3600) + (t[1] * 60)));
	t[3] = (t[0]/24);

	if(t[3] > 0)
		t[0] = t[0] % 24,
		format(String, sizeof(String), "%ddias, %02dh %02dm e %02ds", t[3], t[0], t[1], t[2]);
	else if(t[0] > 0)
		format(String, sizeof(String), "%02dh %02dm e %02ds", t[0], t[1], t[2]);
	else
		format(String, sizeof(String), "%02dm e %02ds", t[1], t[2]);
	return String;
}