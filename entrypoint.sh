#!/bin/bash

find "$INPUT_STRINGS_PATH" -type f -name "$INPUT_STRINGS_FILE_NAME" | while read fname; do
    dirname=`dirname "$fname"`
    foldername=`basename "$dirname"`
    filename=`basename "$fname"`
    newname=`echo "$dirname" | sed -e "s/ /_/g"`
    dest="${INPUT_APP_STRINGS_PATH}/${foldername}"
    dest_file=${dest}/$filename
    src_file=${dirname}/$filename

    # Do special merge to default strings
    if [ $foldername == "values" ]
    then
        out_file=merged.xml
        not_translatable_regex="translatable=\"false\""
        string_tag_regex="(<[^<]*resources[^>]*>)|(<[^<]*xml[^>]*>)"

        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $out_file
        echo "<resources xmlns:android=\"http://schemas.android.com/apk/res/android\">" >> $out_file
        
        # Copy not translatable strings
        while IFS= read -r line
        do
            if [[ "$line" =~ ${not_translatable_regex} ]]; then
                echo "$line" | sed -r "s/^ +/  /g" >> $out_file
            fi;
        done < $dest_file

        # Copy new strings and updates
        while IFS= read -r line
        do
            if [[ ! "$line" =~ ${string_tag_regex} ]]; then
                echo "$line" | sed -r "s/^ +/  /g" >> $out_file
            fi;
        done < $src_file

        echo "</resources>" >> $out_file

        src_file=$out_file
    fi

    mkdir -p $dest && cp $src_file $dest_file
done

cd "${INPUT_APP_PATH}"

git config user.name 'Locale Sync'
git config user.email 'action@github.com'
git checkout -b ${INPUT_PR_BRANCH}
git add .

# Check if has changes to commit
if [[ `git status --porcelain` ]]; then
    git commit -m ${INPUT_PR_COMMIT}
    git push origin ${INPUT_PR_BRANCH}
    hub pull-request \
        --base ${INPUT_APP_BRANCH} \
        --head ${INPUT_PR_BRANCH} \
        -m ${INPUT_PR_TITLE}\
        -m ${INPUT_PR_BODY} \
else
    echo "No changes"
fi;