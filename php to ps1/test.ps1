#######################
#         Param       #
#  setzen in übergabe #
#     owner:sommer    #
#######################

param($param1)

mkdir $param1 

add-pssnapin Quest.ActiveRoles.ADManagement
Unlock-QADUser $param1 

out-file -filepath C:\xampp\htdocs\active\log.txt -inputobject $error -encoding ASCII -width 50

##
#Weitere Funktionen
#PW zurücksetzen ?
#
##