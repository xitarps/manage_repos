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
    # printf '%s\n' "${owners_paths[(($repo_escolhido-1))]}"
    cd "${owners_paths[(($repo_escolhido-1))]}"
    echo ""
    git pull
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

menu_choice=1
clear
while (($menu_choice != 0)) ; do
    
    echo "Menu:"
    echo -e "\n0 - Finalizar este programa"
    echo -e "\n1 - Criar pastas para os repositorios em ./repos"
    echo -e "\n2 - Clonar repositorios git"
    echo -e "\n3 - Configurar projetos rails(caso não tenham sido já configurados/bundle install etc)"
    echo -e "\n4 - Criar, clonar e configurar repos automaticamente"
    echo -e "\n5 - Git pull em todos os repos"
    echo -e "\n6 - Git pull em repo especifico"
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
        7) echo "sete" ;;
        8) echo "oito" ;;
        9) echo "nove" ;;
        10) echo "dez" ;;
        *) echo "Opcao Invalida!" ;;
    esac
    
    menu_choice=$escolhido
done
