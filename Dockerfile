FROM	alpine:3.10
RUN	apk add imagemagick && \
	echo '00 18 * * * /data/anzen_mofa.sh' > /var/spool/cron/crontabs/root && \
	echo '#!/bin/sh' >> /usr/local/bin/entrypoint.sh && \
	echo 'touch /var/log/crond.log' >> /usr/local/bin/entrypoint.sh && \
	echo 'crond -d 8 -L /var/log/crond.log' >> /usr/local/bin/entrypoint.sh && \
	echo 'exec "$@"' >> /usr/local/bin/entrypoint.sh && \
	chmod 755 /usr/local/bin/entrypoint.sh

COPY	anzen_mofa.sh /data/anzen_mofa.sh
ENTRYPOINT	["entrypoint.sh"]
CMD	["tail", "-f", "/var/log/crond.log"]
# composite -compose difference *RiskMap_2.png RiskMap_2_diff.png
