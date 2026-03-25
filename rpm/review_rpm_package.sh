#!/usr/bin/env bash

# Uses built rpm packages in results_saunafs/ to generate a review in
# review-saunafs/review.txt  

read NAME VERSION RELEASE < <(rpmspec -q --qf "%{NAME} %{VERSION} %{RELEASE}\n" saunafs.spec | head -1)

echo "Cleaning old review results..."
rm -rf review-${NAME}

echo "Copying resulting source and rpm packages..."
cp -f results_${NAME}/${VERSION}/${RELEASE}/*.src.rpm .
find results_${NAME}/${VERSION}/${RELEASE}/ -name "*.rpm" ! -name "*debug*" -exec cp -f {} . \;

echo "Running Fedora Review..."
fedora-review -n ${NAME} -p

echo "Review concluded, removing source and rpm packages..."
rm -f ${NAME}-${VERSION}-${RELEASE}.src.rpm
rm -f ${NAME}-*-${VERSION}-${RELEASE}.*.rpm
