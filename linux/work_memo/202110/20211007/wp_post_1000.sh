#!/bin/bash

#エラーが発生した時に停止してくれて、未定義の変数を使うときにエラーになる
set -ue 

#シェルスクリプトにて1000件程度のデータを入れる

#データベースよりURLのページリストを作成する

#ベンチマークテストを行う



#変数のセット
export $(cat /root/.pass)

COUNT=0
TITLE='test'
CONTENT='icbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvlsvnfjkvndskjvfnjkvdvjdvnfvlkjnvkjblvdlvdmnklfvnjdｖんｆｊｖんｋｊｖｂｄｓｋｊｖｂｖｊｋｂｖんｍｖｂｃんｊｖｆんｖｂｄｊふぁいｃｂｊｌしおうｂicbdvbdvjdscjnsdjvdsvdkvnvls'
TAG='test1'
CATEGORY='test1'



#カテゴリーの枠を作成
PATH=$PATH:/usr/local/bin wp term create category test1 --allow-root
PATH=$PATH:/usr/local/bin wp term create category test2 --allow-root
PATH=$PATH:/usr/local/bin wp term create category test3 --allow-root

#タグの枠を作成
PATH=$PATH:/usr/local/bin wp term create post_tag test1 --allow-root
PATH=$PATH:/usr/local/bin wp term create post_tag test2 --allow-root
PATH=$PATH:/usr/local/bin wp term create post_tag test3 --allow-root



#1000件投稿を作成
while [ $COUNT -le 1000 ]
do
    COUNT=$((COUNT+1))
    PATH=$PATH:/usr/local/bin wp post create --post_title=$TITLE$COUNT --post_content=$CONTENT --post_author=1 --post_status=publish --post_category=$CATEGORY --tags_input=$TAG --porcelain --allow-root
    
    if [ $COUNT -eq 100 ]
        then
        TAG='test2'
    elif [ $COUNT -eq 300 ]
        then
        CATEGORY='test2'
    elif [ $COUNT -eq 500 ]
        then
        TAG='test3'
    elif [ $COUNT -eq 750 ]
        then
        CATEGORY='test3'
    elif [ $COUNT -eq 800 ]
        then
        TAG='test2'
    elif [ $COUNT -eq 900 ]
        then
        TAG='test1'
    fi
done



#ベンチマーク用URLリストを作成
/usr/local/mysql5.7/bin/mysql -sN -u wordpress --socket=/usr/local/mysql5.7/data/mysql.sock \
-e"select guid from wpdb.wp_posts where post_type='post';" -p$MYSQL57_WP_PASS > url_list.txt

/usr/local/mysql5.7/bin/mysql -sN -u wordpress --socket=/usr/local/mysql5.7/data/mysql.sock \
-e"select ID from wpdb.wp_users;" -p$MYSQL57_WP_PASS | awk '{print "https://suzuki-t.com/wordpress/?author="$1}' >> url_list.txt

/usr/local/mysql5.7/bin/mysql -sN -u wordpress --socket=/usr/local/mysql5.7/data/mysql.sock \
-e"select t2.name from wpdb.wp_term_taxonomy as t1 inner join wpdb.wp_terms as t2 on t1.term_id = t2.term_id AND t1.taxonomy='post_tag';" \
-p$MYSQL57_WP_PASS | awk '{print "https://suzuki-t.com/wordpress/?tag="$1}' >> url_list.txt

/usr/local/mysql5.7/bin/mysql -sN -u wordpress --socket=/usr/local/mysql5.7/data/mysql.sock \
-e"select term_id from wpdb.wp_term_taxonomy where taxonomy='category';" -p$MYSQL57_WP_PASS \
| awk '{print "https://suzuki-t.com/wordpress/?cat="$1}' >> url_list.txt