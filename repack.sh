#!

BASEDIR=$(dirname "$0")
### Build app
./gradlew jar

WD=${BASEDIR}/`date +%s`
echo "WorkDir dir is ${WD}"
### Repack app
JARDIR=${BASEDIR}/buildGradle/libs
JAR=`ls ${JARDIR} | grep ".jar" | grep "SNAPSHOT"`

if [ "X${JAR}" = "X" ]; then
  echo "jar not found"
  exit 1
fi

echo "JAR is ${JARDIR}/${JAR}"

if [ -d ${BASEDIR}/${WD} ]; then
  rm -rf ${BASEDIR}/${WD}
fi
mkdir ${BASEDIR}/${WD}
cp ${JARDIR}/${JAR} ${BASEDIR}/${WD}
cd ${BASEDIR}/${WD}
jar xvf ${JAR} > /dev/null

rm ${JAR}
rm -rf org/mozilla/javascript/tools/debugger
rm -rf org/mozilla/javascript/tools/shell
javaFiles=`find . -name *.java -print`
for javaFile in ${javaFiles}
  do
    rm ${javaFile}
  done
### Pack
REPACK=rhino-repacked.jar
jar cvf ${REPACK} ./* > /dev/null
cd ..
mv ${WD}/${REPACK} ${JARDIR}
rm -rf ${WD}
echo "Result JAR is ${JARDIR}/${REPACK}"