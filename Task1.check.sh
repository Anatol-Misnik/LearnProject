echo "--------------- Build Started ------------------"
result=`grep "Sergej" index.html | wc -l`
echo $result
if [ "$result" = 1 ]
then
        echo "Test Passed"
    exit 0
else
        echo "Test Feiled"
    exit 1
fi
echo "--------------- Build Finished -----------------"
echo " $GIT_COMMIT"
echo " Build #: $BUILD_NUMBER"
