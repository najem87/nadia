#!/bin/bash

usage() { echo "Usage: `basename $0` <file_to_split> <Separator>" 1>&2; exit 1; }
echo OK 0
[ $# -eq 0 ] && usage
INPUT="$1"
SEPARATOR="$2"
[ ! -f $INPUT ] && echo "[ERR] \"$INPUT\" n'est pas un fichier régulier" && usage
file "$INPUT" | grep -i text > /dev/null
[ $? != 0 ] && echo "[ERR] \"$INPUT\" n'est pas un fichier régulier" && usage
# 15 champs dans le fichier 
NF=`awk -F"$SEPARATOR"  '{ print NF}' "$INPUT" | sort| uniq`
[ "$NF" != "15" ] && echo "[ERR] \"$INPUT\" nombre de champ incorrect dans le fichier" && usage
BASEIN=`basename $INPUT` 
OUTNAME="`echo "${BASEIN%.*}"`"
OUTDIR="$OUTNAME.OUT"
mkdir -p $OUTDIR
LISTEGROUPS=" "
tail -n +2 liste_stagiaire_1.csv | awk -F"$SEPARATOR"  '{ print $4}' | sort| uniq | while read GROUP
do
  echo "GROUP : $GROUP"
  head -1 "$INPUT" > "$OUTDIR/$OUTNAME_$GROUP.csv"
  tail -n +2 liste_stagiaire_1.csv | grep "$SEPARATOR$GROUP$SEPARATOR" >> "$OUTDIR/$OUTNAME_$GROUP.csv"
done

