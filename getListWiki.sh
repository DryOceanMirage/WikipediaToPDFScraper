FIRST="https://en.wikipedia.org/wiki/Special:AllPages"
PREVPAGE="$FIRST"
pageNo=1
getNextPage(){
NEXTPAGE="https://en.wikipedia.org$(curl -s "$PREVPAGE" | grep "Next page" | tail -n 1 | grep -o '<a[^>]*href="[^"]*"[^>]*>Next page' | sed 's/^<a href="//' | sed 's/&amp;/\&/g' | sed 's/" title="Special:AllPages">Next page.*$//')"

if curl -s "$NEXTPAGE" | grep -q "Next page"; then
    echo "Getting Titles from page $pageNo"
    curl "$NEXTPAGE" | grep -A 360 '<ul class="mw-allpages-chunk">' | sed -n 's/.*>\(.*\)<\/a>.*/\1/p' | grep -v 'Next page'| grep -v 'http' | grep -v 'Privacy policy' | grep -v 'About Wikipedia' | grep -v 'Disclaimers' | sed 's/&quot;/\"/g' | sed "s/&#039;/'/g" >> titles.txt && PREVPAGE="$NEXTPAGE" && pageNo=$((pageNo + 1)) && getNextPage
    
else
    curl "$NEXTPAGE" | grep -A 360 '<ul class="mw-allpages-chunk">' | sed -n 's/.*>\(.*\)<\/a>.*/\1/p' | grep -v 'Next page'| grep -v 'http' | grep -v 'Privacy policy' | grep -v 'About Wikipedia' | grep -v 'Disclaimers' | sed 's/&quot;/\"/g' | sed "s/&#039;/'/g" >> titles.txt
    
fi
}
PREVPAGE="$NEXTPAGE"

echo "Getting Titles from page 1"
curl "$FIRST" | grep -A 360 '<ul class="mw-allpages-chunk">' | sed -n 's/.*>\(.*\)<\/a>.*/\1/p' | grep -v 'Next page'| grep -v 'http' | grep -v 'Privacy policy' | grep -v 'About Wikipedia' | grep -v 'Disclaimers' | sed 's/&quot;/\"/g' | sed "s/&#039;/'/g" >> titles.txt

