# frequency_list
A shell script to produce word frequency list of English document

缘起
============
媳妇的课后作业要求多人共同翻译一篇英文文档，如果可以找出论文中的高频核心词汇，在大家动手翻译前确定他们的意义，并对它们的翻译词汇达成一致，就可以有效提高最后产出的翻译全文的质量。

思路
============
输入：待处理英文文档
输出：按词频排序的单词列表
算法：
1、去掉标点符号 tr -d '[:punct:]' | tr '\r\n' ' ' | tr -d '[:cntrl:]'
2、分解为空格分隔的单词（去掉空行和多余空格）tr '\r\n' ' '
3、去掉停词（stop words）,来源：http://www.ranks.nl/stopwords
4、语言处理：变形词、复词等变为词根形式，参考12dicts（http://wordlist.aspell.net/12dicts-readme/）词表，生成英语常用词的变体词表
     从12dicts文档中得到常用词的变体词库：
::
     cat 2+2+3lem.txt | sed 's/ -> \[[a-z]*,*\]//g' > lem
     cat lem | xxd -p | tr -d '\n' | sed 's/0d0a20202020/3d/g' | xxd -r -p > word_variation.txt
5、统计词频并排序输出

参考
============
开源的另一个词频统计脚步：https://github.com/Enaunimes/freeq
获取停词列表：http://www.ranks.nl/stopwords
变体词：http://wordlist.aspell.net/12dicts-readme/

杂项MISC
============
运行环境：依赖GNU command line tools(grep, awk, sed, etc.)
使用
::
./frequence_list.sh -i <input_file> -o <output_file>
License：BSD-2-Clause license
