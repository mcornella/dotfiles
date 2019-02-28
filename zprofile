if [[ $OSTYPE = linux* && "$(uname -r)" =~ "Microsoft" ]]; then
    skip_global_compinit=1
fi
