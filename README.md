# find-pronunciation-of-English-words
根据单词列表自动查找对应的发音文件。

list_pronunciation.sh	bash脚本。查找的都是美式发音。读取all_list.txt中的单词，首先从src目录中查找对应的发音，没有会从金山词霸上查找真人发音，再没有会从bing词典上查找。
all_list.txt  所有单词列表，为脚本的输入文件。现在包括：中考、高考、CET4、CET6、专CET8、TOEFL、IELTS、GRE所有单词，去掉了参考文档的错词和一些没找到发音的短语，共15563个词。
src	目录存放某词典的发音文件。来源网上。
des	目录存放查找到的发音文件。
miss_list.txt	输出文件。记录没有找到发音的单词，共12个词。

所有发音文件均来源网上，我不具有其所有权，仅用于个人学习。请务用于商业目的，你将承担相应的法律风险。
