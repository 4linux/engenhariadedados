# Criando um modelo preditivo de aprendizagem não-supervisionada

# Cria uma pasta no HDFS
hdfs dfs -mkdir /mahout/clustering
hdfs dfs -mkdir /mahout/clustering/data

# Copia os datasets para o HDFS
hdfs dfs -copyFromLocal news/* /mahout/clustering/data
hdfs dfs -cat /mahout/clustering/data/*

# Converte o dataset para objeto sequence
mahout seqdirectory -i /mahout/clustering/data -o /mahout/clustering/kmeansseq

# Converte a sequence para objetos TF-IDF vectors
mahout seq2sparse -i /mahout/clustering/kmeansseq -o /mahout/clustering/kmeanssparse

hdfs dfs -ls /mahout/clustering/kmeanssparse

# Construindo o modelo K-means
#	-i	diretório com arquivos de entrada
#	-c	diretório de destino para os centroids
#	-o	diretório de saída
#	-k	número de clusters
#	-ow	overwrite 
#	-x	número de iterações
#	-dm	medida de distância
mahout kmeans -i /mahout/clustering/kmeanssparse/tfidf-vectors/ -c /mahout/clustering/kmeanscentroids  -cl -o /mahout/clustering/kmeansclusters -k 3 -ow -x 10 -dm org.apache.mahout.common.distance.CosineDistanceMeasure

hdfs dfs -ls /mahout/clustering/kmeansclusters

# Dump dos clusters para um arquivo texto
mahout clusterdump -d /mahout/clustering/kmeanssparse/dictionary.file-0 -dt sequencefile -i /mahout/clustering/kmeansclusters/clusters-1-final -n 20 -b 100 -o clusterdump.txt -p /mahout/clustering/kmeansclusters/clusteredPoints/

# Visualiza os clusters.
cat clusterdump.txt

