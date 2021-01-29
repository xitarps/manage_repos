#! /bin/bash
create_dirs(){
    input_filename='repo_list.txt'
    n=1
    owner="nil"
    current_repo="nil"
    clear
    echo -e "\nCriando pastas..."
    sleep 2
    mkdir ./repos
    while IFS= read -r line; do
        # reading each line
        #echo "Line No. $n : $line"
        owner=$(echo $line | cut -d '/' -f 4)
        current_repo=$(echo $line | cut -d '/' -f 5)
        #echo "Owner: $owner"
        #echo "Current repo: $current_repo"
        n=$((n+1))
        #echo ""
        mkdir ./repos/$owner
    done < $input_filename
    clear
    echo -e "\nForam criadas $n pastas(caso não existissem)"
    echo -e "em: $PWD/repos/"
    echo -e "\n...\n\n\n\n\n"
}

clone_git_repos(){
    input_filename='repo_list.txt'
    n=1
    owner="nil"
    current_repo="nil"
    clear
    echo -e "\nClonando repos..."
    sleep 2
    
    current_path=$PWD
    while IFS= read -r line; do
        # reading each line
        #echo "Line No. $n : $line"
        owner=$(echo $line | cut -d '/' -f 4)
        current_repo=$(echo $line | cut -d '/' -f 5)
        echo "Endereço: $line"
        echo "Owner: $owner"
        echo "Current repo: $current_repo"
        echo
        
        cd $current_path/repos/$owner
        git clone $line
        
    done < $input_filename
    clear
    echo -e "\nOs repositorios foram clonados(caso não existissem)"
    echo -e "em: $PWD/repos/"
    echo -e "\n...\n\n\n\n\n"
    cd $current_path/
}

config_rails_projects(){
    input_filename='repo_list.txt'
    n=1
    owner="nil"
    current_repo="nil"
    clear
    echo -e "\nConfigurando projetos..."
    sleep 2
    
    current_path=$PWD
    while IFS= read -r line; do
        # reading each line
        #echo "Line No. $n : $line"
        owner=$(echo $line | cut -d '/' -f 4)
        current_repo=$(echo $line | cut -d '/' -f 5)
        echo "Endereço: $line"
        echo "Owner: $owner"
        echo "Current repo: $current_repo"
        echo
        
        cd $current_path/repos/$owner/$current_repo
        
        # get output from bundle
        exec 3>&1                    # Save the place that stdout (1) points to.
        rbv=$(bundle install 2>&1 1>&3)  # Run command.  stderr is captured.
        exec 3>&-                    # Close FD #3.
      
        #echo "rbv: $rbv"
        
        sleep 2
        
        STR="$rbv"
        SUB="Your Ruby version"
        if [[ "$STR" == *"$SUB"* ]]; then 
        
            rbv=$(echo "${rbv: -6}")
            echo "different versions of ruby..."
            echo "now using: $rbv"
            sleep 3
            # Load RVM into a shell session *as a function*
            if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then

                # First try to load from a user install
                source "$HOME/.rvm/scripts/rvm"

            elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then

                # Then try to load from a root install
                source "/usr/local/rvm/scripts/rvm"

            elif [[ -s "/usr/share/rvm/scripts/rvm" ]] ; then

                # Then try to load from a root install
                source "/usr/share/rvm/scripts/rvm"

            else

                printf "ERROR: An RVM installation was not found.\n"
            fi &&
            
            rvm use $rbv
            bundle install
            
            echo -e "\n -->>>>>>>>>Errors Solved on $owner / ruby version\n\n"; 
            
        else 
            echo -e "\n -->>>>>>>>>No Errors on $owner\n\n"
        fi
        sleep 2
        
        yarn install && rails db:migrate && rails db:seed
    done < $input_filename
    cd $current_path/
    echo -e "\nOs repositorios locais foram configurados."
    echo -e "\n...\n\n\n\n\n"
    sleep 2
}

config_one_rails_project(){
    input_filename='repo_list.txt'
    n=1
    owner="nil"
    current_repo="nil"
    clear
    owner=$1
    owner_path=$2
    
    echo -e "\nConfigurando projeto de...\n"
    echo ">>> $owner"
    echo -e "\n\nProjeto: \n"
    echo $owner_path | rev | cut -d '/' -f 1 | rev
    sleep 2
    
    current_path=$PWD
    echo -e "\nCurrentpath: $PWD"
    sleep 4
    current_repo=$(echo $owner_path | rev | cut -d '/' -f 1 | rev)
    sleep 10
    cd $current_path/repos/$owner/$current_repo
    
    # get output from bundle
    exec 3>&1                    # Save the place that stdout (1) points to.
    rbv=$(bundle install 2>&1 1>&3)  # Run command.  stderr is captured.
    exec 3>&-                    # Close FD #3.
  
    #echo "rbv: $rbv"
    
    sleep 2
    
    STR="$rbv"
    SUB="Your Ruby version"
    if [[ "$STR" == *"$SUB"* ]]; then 
    
        rbv=$(echo "${rbv: -6}")
        echo "different versions of ruby..."
        echo "now using: $rbv"
        sleep 3
        # Load RVM into a shell session *as a function*
        if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then

            # First try to load from a user install
            source "$HOME/.rvm/scripts/rvm"

        elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then

            # Then try to load from a root install
            source "/usr/local/rvm/scripts/rvm"

        elif [[ -s "/usr/share/rvm/scripts/rvm" ]] ; then

            # Then try to load from a root install
            source "/usr/share/rvm/scripts/rvm"

        else

            printf "ERROR: An RVM installation was not found.\n"
        fi &&
        
        rvm use $rbv
        bundle install
        
        echo -e "\n -->>>>>>>>>Errors Solved on $owner / ruby version\n\n"; 
        
    else 
        echo -e "\n -->>>>>>>>>No Errors on $owner\n\n"
    fi
    sleep 2
    
    yarn install && rails db:migrate && rails db:seed
        

    cd $current_path/
    echo -e "\nO repositorio local foi configurado."
    echo -e "\n...\n\n\n\n\n"
    sleep 2
}

git_pull_repos(){
    input_filename='repo_list.txt'
    n=0
    owner="nil"
    current_repo="nil"
    clear
    echo -e "\nGit pull dos repos..."
    sleep 2
    
    current_path=$PWD
    while IFS= read -r line; do
        # reading each line
        #echo "Line No. $n : $line"
        owner=$(echo $line | cut -d '/' -f 4)
        current_repo=$(echo $line | cut -d '/' -f 5)
        echo "Endereço: $line"
        echo "Owner: $owner"
        echo "Current repo: $current_repo"
        echo
        
        cd $current_path/repos/$owner/$current_repo
        git pull
        echo -e "\n----------\n"
    done < $input_filename
    sleep 2
    cd $current_path/
    config_rails_projects &&
    sleep 3
    clear
    echo -e "\n Os repositorios locais foram atualizados(caso tivessem alterações)"
    echo -e "\n...\n\n\n\n\n"
    cd $current_path/
}

git_pull_single_repo(){
    input_filename='repo_list.txt'
    n=1
    owner="nil"
    current_repo="nil"
    clear
    echo -e "\nGit pull de repo específico...\n"
    sleep 2
    
    owners=()
    owners_paths=()
    
    current_path=$PWD
    while IFS= read -r line; do
        # reading each line
        #echo "Line No. $n : $line"
        owner=$(echo $line | cut -d '/' -f 4)
        current_repo=$(echo $line | cut -d '/' -f 5)
        #echo "Endereço: $line"
        echo "$n - $owner"
        #owners[$(($n-1))]="$owner"
        #owners_paths[$(($n-1))]="$current_path/repos/$owner/$current_repo"
        
        owners+=("$owner")
        owners_paths+=("$current_path/repos/$owner/$current_repo")
        n=$(($n+1))
        #echo "Current repo: $current_repo"
        #echo
        
        #cd $current_path/repos/$owner/$current_repo
        #git pull
        #echo -e "\n----------\n"
    done < $input_filename
    #clear
    #printf '%s\n' "${owners[@]}"
    #printf '%s\n' "${owners_paths[@]}"
    echo ""
    read -p 'Atualizar qual repo(digite apenas o numero):' repo_escolhido

    echo -e "\nAtualizando o repo de:\n\n"
    printf ' >>>     %s\n' "${owners[(($repo_escolhido-1))]}     <<<"
    echo ""
    printf '%s\n' "${owners_paths[(($repo_escolhido-1))]}"
    cd "${owners_paths[(($repo_escolhido-1))]}"
    echo ""
    git pull
    sleep 2
    cd $current_path/
    user_proj="${owners[(($repo_escolhido-1))]}"
    caminho_proj="${owners_paths[(($repo_escolhido-1))]}"
    # echo $caminho_proj
    # sleep 10
    config_one_rails_project $user_proj $caminho_proj
    echo -e "\nO repositorio local foi atualizado(caso tivessem alterações)"
    cd $current_path/
    sleep 4
    clear
}

full_get_repos(){
    create_dirs &&
    clone_git_repos &&
    config_rails_projects
}

run_rails_server(){
    input_filename='repo_list.txt'
    n=1
    owner="nil"
    current_repo="nil"
    clear
    echo -e "\nRun Rails server...\n"

    owners=()
    owners_paths=()
    
    current_path=$PWD
    while IFS= read -r line; do
        # reading each line
        #echo "Line No. $n : $line"
        owner=$(echo $line | cut -d '/' -f 4)
        current_repo=$(echo $line | cut -d '/' -f 5)
        #echo "Endereço: $line"
        echo "$n - $owner"
        #owners[$(($n-1))]="$owner"
        #owners_paths[$(($n-1))]="$current_path/repos/$owner/$current_repo"
        
        owners+=("$owner")
        owners_paths+=("$current_path/repos/$owner/$current_repo")
        n=$(($n+1))
        #echo "Current repo: $current_repo"
        #echo
        
        #cd $current_path/repos/$owner/$current_repo
        #git pull
        #echo -e "\n----------\n"
    done < $input_filename
    #clear
    #printf '%s\n' "${owners[@]}"
    #printf '%s\n' "${owners_paths[@]}"
    echo ""
    read -p 'Rodar Rails Server de qual projeto?(digite apenas o numero):' repo_escolhido

    echo -e "\nInicializando rails server do projeto de:\n\n"
    printf ' >>>     %s\n' "${owners[(($repo_escolhido-1))]}     <<<"
    echo ""
    # printf '%s\n' "${owners_paths[(($repo_escolhido-1))]}"
    cd "${owners_paths[(($repo_escolhido-1))]}"
    echo ""



    # get output from bundle
    exec 3>&1                    # Save the place that stdout (1) points to.
    rbv=$(bundle install 2>&1 1>&3)  # Run command.  stderr is captured.
    exec 3>&-                    # Close FD #3.
  
    #sleep 2
    
    STR="$rbv"
    SUB="Your Ruby version"
    if [[ "$STR" == *"$SUB"* ]]; then 
    
        rbv=$(echo "${rbv: -6}")
        echo "different versions of ruby..."
        
        # Load RVM into a shell session *as a function*
        if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then

            # First try to load from a user install
            source "$HOME/.rvm/scripts/rvm"

        elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then

            # Then try to load from a root install
            source "/usr/local/rvm/scripts/rvm"

        elif [[ -s "/usr/share/rvm/scripts/rvm" ]] ; then

            # Then try to load from a root install
            source "/usr/share/rvm/scripts/rvm"

        else

            printf "ERROR: An RVM installation was not found.\n"
        fi
        rvm use $rbv
    fi
    
    echo -e "now using:\n"
    rvm list
    echo ""
    sleep 2
    rails s -b 0.0.0.0



    echo -e "\n\nRetornando ao menu..."
    cd $current_path/
    sleep 2
    clear
}
logo(){
echo '                                                                   '
echo ' _ __ ___   __ _ _ __   __ _  __ _  ___   _ __ ___ _ __   ___  ___ '
echo '| `_ ` _ \ / _` | `_ \ / _` |/ _` |/ _ \ | `_| __ \ `_ \ / _ \/ __|'
echo '| | | | | | (_| | | | | (_| | (_| |  __/ | | |  __/ |_) | (_) \__ \'
echo '|_| |_| |_|\__,_|_| |_|\__,_|\__, |\___| |_|  \___| .__/ \___/|___/'
echo '                             |___/                |_|              '
echo ''
#thanks to figlet - http://www.figlet.org/ - ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.5.tar.gz
}

menu_choice=1
clear
while (($menu_choice != 0)) ; do
    logo
    echo -e "\nManage repos by: Xita rps\n\nhttps://github.com/xitarps\n\n"
    echo "Menu:"
    echo -e "\n0 - Exit / Sair "
    echo -e "\n1 - Create folders for repos/ Criar pastas para os repositorios"
    echo -e "\n2 - Clone git repos / Clonar repositorios git"
    echo -e "\n3 - Configure rails projects / Configurar projetos rails(ex: bundle install etc)"
    echo -e "\n4 - Create, Clone, Configure / Criar, clonar e configurar"
    echo -e "\n5 - Git pull in all repos / Git pull em todos os repos"
    echo -e "\n6 - Git pull in only one repo / Git pull em um único repo"
    echo -e "\n7 - Rails server of a project / Rails server de um projeto"
    echo ""
    read -p 'Digite sua escolha:' escolhido
    
    case $escolhido in
        0) echo "Finalizando.." && sleep 1 && clear ;;
        1) create_dirs ;;
        2) clone_git_repos ;;
        3) config_rails_projects ;;
        4) full_get_repos ;;
        5) git_pull_repos ;;
        6) git_pull_single_repo ;;
        7) run_rails_server ;;
        8) echo "oito" ;;
        9) echo "nove" ;;
        10) echo "dez" ;;
        *) echo "Opcao Invalida!" ;;
    esac
    
    menu_choice=$escolhido
done
