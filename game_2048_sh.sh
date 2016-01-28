#!/bin/sh


#$1:index of array
get_element(){
    case $1 in
    0)  return $n0  ;;
    1)  return $n1  ;;
    2)  return $n2  ;;
    3)  return $n3  ;;
    4)  return $n4  ;;
    5)  return $n5  ;;
    6)  return $n6  ;;
    7)  return $n7  ;;
    8)  return $n8  ;;
    9)  return $n9  ;;
    10) return $n10 ;;
    11) return $n11 ;;
    12) return $n12 ;;
    13) return $n13 ;;
    14) return $n14 ;;
    15) return $n15 ;;
    esac

}
#$1:index of array ,$2: setting value
set_arr(){
    case $1 in
        0)  arr0="$2";;
        1)  arr1="$2";;
        2)  arr2="$2";;
        3)  arr3="$2";;
        4)  arr4="$2";;
        5)  arr5="$2";;
        6)  arr6="$2";;
        7)  arr7="$2";;
        8)  arr8="$2";;
        9)  arr9="$2";;
        10) arr10="$2";;
        11) arr11="$2";;
        12) arr12="$2";;
        13) arr13="$2";;
        14) arr14="$2";;
        15) arr15="$2";;
    esac

}









show_2048(){
    i=0

    while [ "$i" -le 15 ]; do
        get_element $i

        item="$?"
        if [ "$item" -ne 0 ];then
            if [ "$item" -lt 10 ] ;then
                set_arr $i  "\Z4   $item\Zn"
            elif [ "$item" -lt 100 ] ;then
                set_arr $i  "\Z2  $item\Zn"
            elif [ "$item" -lt 1000 ] ; then
                set_arr $i  "\Z1 $item\Zn"
            else
                set_arr $i  "\Z6$item\Zn"
            fi
#win condition
            if [ "$item" -eq 2048 ];then   #target score
                win_game=true
            fi

        else
            eval arr$i=" "

        fi
        i=`expr $i + 1`
    done





    dialog --title "2048 GAME" --colors   --infobox "\
 _______________________\n\
|     |     |     |     |\n\
`printf "|%4s |%4s |%4s |%4s |" "$arr0" "$arr1" "$arr2" "$arr3"`\n\
|_____|_____|_____|_____|\n\
|     |     |     |     |\n\
`printf "|%4s |%4s |%4s |%4s |" "$arr4" "$arr5" "$arr6" "$arr7"`\n\
|_____|_____|_____|_____|\n\
|     |     |     |     |\n\
`printf "|%4s |%4s |%4s |%4s |" "$arr8" "$arr9" "$arr10" "$arr11"`\n\
|_____|_____|_____|_____|\n\
|     |     |     |     |\n\
`printf "|%4s |%4s |%4s |%4s |" "$arr12" "$arr13" "$arr14" "$arr15"`\n\
|_____|_____|_____|_____|\n\
" 25 40









}

new_game(){
    i=0
    while [ "$i" -ne 16  ]; do
        #echo "$i" >> gamedata.txt
        eval n$i=" "
        i=`expr $i + 1`
    done
    capacity=16
    generate_new_brick
    generate_new_brick
#    n0=32
#    n4=32
#    n8=4
#    n12=2
#    capacity=12
}

generate_new_brick(){

   if [ "$capacity" -gt 0 ]; then
        #capacity-1+1
        upper_bound=`expr $capacity - 1`

        #for freebsd /bin/sh
        index=`jot -r 1 0 $upper_bound`  #range:0~15 (but %i need max_plus_one) 1: number of data 0:low bound $upper_bound: high bound
        #for linux /bin/bash
        #index=$((RANDOM%$capacity))
        i=0
        while [ "$i" -le 15 ] ; do
            get_element $i
            item="$?"
            if [ "$index" -eq 0 ] && [ "$item" -eq 0  ] ; then
                #for freebsd /bin/sh
                odd_even=`jot -r 1 0 100`
                #for linux /bin/bash
                #odd_even=$((RANDOM%100))
                odd_even=`expr $odd_even % 2`
                if [ "$odd_even" -eq 0  ]; then
                    eval n$i="2"
                else
                    eval n$i="4"
                fi
                capacity=`expr $capacity - 1`
                break
            elif [ "$index" -gt 0 ] && [ "$item" -eq 0 ] ; then
                index=`expr $index - 1`
            fi
            i=`expr $i + 1`
        done
    fi
}
#$1:row $2:col $3:direction
merge_brick(){
    current_index=`expr $1 \* 4 + $2`
    get_element $current_index
    current_item="$?"

    if [ "$3" = up ]; then
        search_index=`expr $current_index + 4`
        while [ "$search_index" -le 15 ] ; do

            get_element  $search_index
            search_item="$?"
            if [ "$search_item" = $current_item ] && [ $current_item -ne 0 ]; then
                eval n$current_index=`expr $current_item \* 2`
                eval n$search_index=" "
                change=true
                capacity=`expr $capacity + 1`
                break
            elif [ "$search_item" -ne 0  ] ; then
                break
            fi
            search_index=`expr $search_index + 4`
        done

    elif [ "$3" = left ] ; then
        search_index=`expr $current_index + 1`
        while [ "$search_index" -lt $(( ($current_index / 4+1)*4)) ] ; do

            get_element  $search_index
            search_item="$?"
            if [ "$search_item" = $current_item ] && [ $current_item -ne 0 ]; then
                eval n$current_index=`expr $current_item \* 2`
                eval n$search_index=" "
                change=true
                capacity=`expr $capacity + 1`
                break
            elif [ "$search_item" -ne 0  ] ; then
                break
            fi
            search_index=`expr $search_index + 1`
        done


    elif [ "$3" = down ] ; then

        search_index=`expr $current_index - 4`
        while [ "$search_index" -ge 0 ] ; do

            get_element  $search_index
            search_item="$?"
            if [ "$search_item" = $current_item ] && [ $current_item -ne 0 ]; then
                eval n$current_index=`expr $current_item \* 2`
                eval n$search_index=" "
                change=true
                capacity=`expr $capacity + 1`
                break
            elif [ "$search_item" -ne 0  ] ; then
                break
            fi
            search_index=`expr $search_index - 4`
        done

    elif [ "$3" = right ] ; then
        search_index=`expr $current_index - 1 `
        while [ "$search_index" -ge $(( ($current_index / 4 ) * 4 ))   ] ;do
            get_element $search_index
            search_item="$?"
            if [ "$search_item" = $current_item ] && [ $current_item -ne 0 ]; then
                eval n$current_index=`expr $current_item \* 2`
                eval n$search_index=" "
                change=true
                capacity=`expr $capacity + 1`
                break
            elif [ "$search_item" -ne 0 ]; then
                break
            fi
            search_index=`expr $search_index - 1 `
        done
    fi
}

shuffle(){
#fine the space
    if [ "$1" = up ];then
        i=0
        while [ "$i" -le 15 ] ;do
            get_element $i
            item="$?"
            if [ "$item" -eq 0  ]; then
                search_index=`expr $i + 4`
                while [ "$search_index" -le 15 ]; do
                    get_element $search_index
                    item="$?"
                    if [ "$item" -ne 0 ]; then
                        eval n$i="$item"
                        eval n$search_index=" "
                        change=true
                        break
                    fi
                    search_index=`expr $search_index + 4`
                done
            fi
            i=`expr $i + 1`
        done
    elif [ "$1" = left ];then
        i=0
        while [ "$i" -le 15 ] ;do
            get_element $i
            item="$?"
            search_index=`expr $i + 1`
            if [ "$item" -eq 0  ]; then
                while [ "$search_index" -lt $(( ($i / 4 + 1) * 4 ))  ]; do
                    get_element $search_index
                    item="$?"
                     if [ "$item" -ne 0 ]; then
                        eval n$i="$item"
                        eval n$search_index=" "
                        change=true
                        break
                    fi
                    search_index=`expr $search_index + 1`
                done
            fi
            i=`expr $i + 1`
        done
    elif [ "$1" = down ];then
        i=15
		while [ "$i" -ge 0 ] ;do
			get_element $i
			item="$?"
			search_index=`expr $i - 4`
			if [ "$item" -eq 0  ]; then
				while [ "$search_index" -ge 0 ]; do
					get_element $search_index
					item="$?"
					if [ "$item" -ne 0 ]; then
						eval n$i="$item"
						eval n$search_index=" "
						change=true
						break
					fi
					search_index=`expr $search_index - 4`
				done
			fi
			i=`expr $i - 1`
		done


    elif [ "$1" = right ]; then
        i=15
        while [ "$i" -ge 0 ];do
            get_element $i
            item="$?"


            if [ "$item" -eq 0 ] ; then
               search_index=`expr $i - 1`
               while [ "$search_index"  -ge  $(( ($i / 4 ) * 4 ))  ] ; do
                   get_element $search_index
                   item="$?"
                   if [ "$item" -ne 0 ] ; then
                       eval n$i="$item"
                       eval n$search_index=" "
                       change=true
                       break
                    fi
                   search_index=`expr $search_index - 1`
                done
            fi
            i=`expr $i - 1`
        done
    fi



}


show_winmessage(){
    win_game=false
    opengame=false
    dialog --title "You win the game" --msgbox  "             \n\
     _      _       _    _________    ___     _               \n\
    \ \    /  \    / /  |___   ___|  |   \   | |              \n\
     \ \  / /\ \  / /       | |      | |\ \  | |              \n\
      \ \/ /  \ \/ /        | |      | | \ \ | |              \n\
       \  /    \  /      ___| |___   | |  \ \| |              \n\
        \/      \/      |_________|  |_|   \___|              \n\
         " 20 60
}



playing(){

#dialog --input-fd keyboard
    flag=true

    while [ "$flag" = true ]; do

        stty raw -echo
        key=`dd bs=1 count=1 2>/dev/null`
        stty -raw echo

        case $key in
        'w'|'a')
            if [ "$key" = "w" ]; then
                action="up"
            else
                action="left"
            fi
            change=false  #defaule:Not Change
            row=0
            while [ "$row" -le 3 ]; do
                col=0
                while [ "$col" -le 3 ]; do
                    pos=`expr 4 \* $row + $col`
                    get_element $pos
                    item="$?"
                    if [ "$item" -ne 0 ]; then
                        merge_brick $row $col $action
                    fi
                    col=`expr $col + 1`
                done
                row=`expr $row + 1`
            done
            shuffle $action

            if [ "$change" = true  ]; then
               generate_new_brick
            fi
            ;;

        's'| 'd')
            if [ "$key" = "s" ] ;then
				action="down"
			else
				action="right"
			fi
			change=false

            row=3
			while [ "$row" -ge 0 ]; do
				col=3
				while [ "$col" -ge 0 ]; do
					pos=` expr 4 \* $row + $col`
					get_element $pos
					item="$?"
					if [ "$item" -ne 0 ]; then
						merge_brick $row $col $action
					fi
					col=`expr $col - 1`
				done
				row=`expr $row - 1`
			done

            shuffle $action
			if [ "$change" = true ]; then
				generate_new_brick
			fi
			;;
        'q')
            flag=false
            ;;
        esac
        show_2048
        if [ "$win_game" = true ] ; then
            sleep 2
            show_winmessage
            flag=false
        fi
    done
}
save_game(){
    i=0
    count_record=`ls -l record* | wc -l`
    if [ "$count_record" -ge  5 ]; then
        remove_name=`ls -l record* | awk 'NR==1{ print $9}' `
        rm -rf $remove_name

    fi

    record_name="record_"`date +%Y-%m-%d_%H:%M:%S`"_gamedata.txt"

    while [ "$i" -le 15 ]; do
        get_element $i
        item="$?"
        echo "$item">>$record_name
        i=`expr $i + 1`
    done
    dialog --title "Saving Game" --msgbox "Game has been saved" 20 45

}

load_game(){
    i=0
    while read line ; do
        eval n$i="$line"
        i=`expr $i + 1`
    done < "$1"

    dialog --title "Loading gmae" --msgbox "Game has been loaded" 20 45

}



dialog --title "2048 GAME " --ok-label "Play a game"  --msgbox "      Welcome 2048   \n\
   _______   __         __   ___  ______         \n\
  /  ____/  /  \       /  \_/  / / ____/         \n\
 /  / __   / /\ \     / /\__/ / / /___           \n\
/  /_/ /  / /__\ \   / /   / / / /___            \n\
\_____/  /_/    \_\ /_/   /_/ /_____/            \n\
  _____   _____   _   _   _____               \n\
 |___  | |  _  | | | | | |  _  |              \n\
  ___| | | | | | | |_| | | |_| |              \n\
 |  ___| | | | | |___  | |  _  |              \n\
 | |___  | |_| |     | | | |_| |              \n\
 |_____| |_____|     |_| |_____|              \n\
                                                 \n\
                                                    \n\
" 20  45


in_game=true
opengame=false
while [ "$in_game" = true ] ; do
    dialog --clear --title "Menu"  --menu "Commamd Line 2048"  20 50 5   \
    N "New Game - Start a new 2048 game" \
    R "Resume-Resume previos game" \
    L "Load - Load from previous saved game" \
    S "Save current game" \
    Q "Quit" 2>"_2048menu.txt"



    menuitem=`cat _2048menu.txt `
    case $menuitem in
        N)
            opengame=true
            new_game
            show_2048
            playing

        ;;
        R)
            if [ "$opengame" = false ] ; then
                dialog --title "Warning" --msgbox "Haven't start a game" 20 60
            else
                show_2048
                playing
            fi
        ;;
        L)
            all_record=`ls -l record* | awk '{ print $9}' `

            record1="---No Data---"
            record2="---No Data---"
            record3="---No Data---"
            record4="---No Data---"
            record5="---No Data---"

            count_record=0
            for name in $all_record ; do
                count_record=`expr $count_record + 1 `
                eval record$count_record=$name
            done

            rm -rf "_record_select.txt"
            dialog --clear --title "Record"  --menu "Select Record"  20 50 6   \
                1 "$record1"\
                2 "$record2"\
                3 "$record3"\
                4 "$record4"\
                5 "$record5"\
                Q "Quit" 2>"_record_select.txt"

            record_item=`cat _record_select.txt`

            if [ "$record_item" = Q ] ; then
                :#do notging
            elif [ "$record_item" -gt $count_record  ] ; then
                dialog --title "Watning"  --msgbox "You selecte no Data" 20 60
            else
                case $record_item in
                1)
                    load_game $record1
                ;;
                2)
                    load_game $record2
                ;;
                3)
                    load_game $record3
                ;;
                4)
                    load_game $record4
                ;;
                5)
                    load_game $record5
                ;;
                esac
                 opengame=true
            fi
        ;;
        S)
            if [ "$opengame" = false ] ; then
                dialog --title "Warning" --msgbox  "Haven't start a game \nYou cannot save game" 20 60
            else
                save_game
            fi
        ;;
        Q) echo "Bye"
           in_game=false
        ;;
    esac
    rm -rf _2048menu.txt
done
