#!/bin/bash


# let's use variables instead of writing same long strings again and again
var_uri1="https://api.themoviedb.org/3/movie/"
var_uri2="https://api.themoviedb.org/3/person/"
var_api_key="api_key=XXXXXXXXXX" # create account to obtain it


var_counter=1

# show a menu
clear
echo
echo -e "\t\tMovies currently in theaters"
echo
echo -e "\t\t1. Titles only"
echo -e "\t\t2. Full details"
echo -e "\t\t0. Exit"
echo
echo -e -n "\t\t"
read -p "Option : " option

# action based on menu option
case "$option" in
  0)
    echo
    echo "Exiting..."
    sleep 3
    clear
    exit
    ;;

  1)
    clear
    echo
    echo -e -n "\t"
    read -p "Insert region (gr,us,uk,...) : " var_region
    echo
    echo
    echo -e "\t\t\t\tRetrieving movies for "$var_region
    echo
    echo
    # get id for every movie playing now in theaters, in Greece
    for var_movie in `curl --silent --request GET   --url $var_uri1'now_playing?page=1&region='$var_region'&'$var_api_key   --data '{}' | jq .results[].id`;
    do

      # for every id (movie) show :

      # title
      echo -e -n "\t\t\t\t"
      curl --silent --request GET   --url $var_uri1$var_movie"?"$var_api_key   --data '{}' | jq .title
      ((var_counter++))
   done
   echo
   echo -e "\t\t\t\tTotal movies : "$var_counter
   echo
   exit
   ;;


  2)
    clear
    echo
    echo -e -n "\t"
    read -p "Insert region (gr,us,uk,...) : " var_region
    echo
    echo
    echo -e "\t\t\t\tRetrieving movies for "$var_region
    echo
    echo

    # get id for every movie playing now in theaters, in Greece
    for var_movie in `curl --silent --request GET   --url $var_uri1'now_playing?page=1&region='$var_region'&'$var_api_key   --data '{}' | jq .results[].id`;
    do
      echo -e "\t\t\t\tMovie No : "$var_counter

      # for every id (movie) show :

      # title
      echo -n "Title --> "
      curl --silent --request GET   --url $var_uri1$var_movie"?"$var_api_key   --data '{}' | jq .title

      # overview
      echo -n "Description --> "
      curl --silent --request GET   --url $var_uri1$var_movie"?"$var_api_key   --data '{}' | jq .overview

      # original_title
      echo -n "Original Title --> "
      curl --silent --request GET   --url $var_uri1$var_movie"?"$var_api_key   --data '{}' | jq .original_title

      # list of directors

      for var_director in `curl --silent --request GET   --url $var_uri1$var_movie'/credits?'$var_api_key   --data '{}' | jq '.crew[] | select(.job=="Director") | .id'`;
      do
        echo -n "Director's name --> "
        curl --silent --request GET   --url $var_uri2$var_director"?"$var_api_key   --data '{}' | jq .name
        var_director_imdb=`curl --silent --request GET   --url $var_uri2$var_director"?"$var_api_key   --data '{}' | jq .imdb_id | sed 's/"//g'`
        echo "Director's IMDB link -->  http://www.imdb.com/name/"$var_director_imdb"/"

      done
      echo
      echo
      ((var_counter++))
    done
    exit
    ;;
esac
