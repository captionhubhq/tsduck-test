#!/usr/bin/env bash
# Plugin ttml: extraction of DVB-TTML subtitles (ETSI EN 303 560).
# The input is the same as test-211: the IRT TTML test stream, without its
# video, audio and stuffing, which DVB publishes under the Creative Commons
# Attribution 4.0 license:
# https://dvb.org/specifications/verification-validation/dvb-ttml-subtitling-test-streams/

source $(dirname $0)/../common/testrc.sh
test_cleanup "$SCRIPT.*"

test_tsp \
    -I file $(fpath "$INDIR/test-211.ts") \
    -P ttml -o $(fpath "$OUTDIR/$SCRIPT.ttml.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.log" 2>&1

test_text $SCRIPT.ttml.txt
test_text $SCRIPT.tsp.log

mkdir -p "$OUTDIR/$SCRIPT.documents"
test_tsp \
    -I file $(fpath "$INDIR/test-211.ts") \
    -P ttml --language deu --max-documents 2 -d $(fpath "$OUTDIR/$SCRIPT.documents") -o $(fpath "$OUTDIR/$SCRIPT.ttml.deu.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.deu.log" 2>&1

test_text $SCRIPT.ttml.deu.txt
test_text $SCRIPT.tsp.deu.log
test_bin $SCRIPT.documents/ttml-046A-000001.xml
test_bin $SCRIPT.documents/ttml-046A-000002.xml

mkdir -p "$OUTDIR/$SCRIPT.nodup"
test_tsp \
    -I file $(fpath "$INDIR/test-211.ts") \
    -P ttml --language deu --no-duplicate --max-documents 2 -d $(fpath "$OUTDIR/$SCRIPT.nodup") -o $(fpath "$OUTDIR/$SCRIPT.ttml.nodup.txt") \
    -O drop \
    >"$OUTDIR/$SCRIPT.tsp.nodup.log" 2>&1

test_text $SCRIPT.ttml.nodup.txt
test_text $SCRIPT.tsp.nodup.log
test_bin $SCRIPT.nodup/ttml-046A-000001.xml
test_bin $SCRIPT.nodup/ttml-046A-000004.xml
