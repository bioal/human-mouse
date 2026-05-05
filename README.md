# human-mouse orthology

- humanとmouseのアミノ酸配列をall vs allで比較
  - アラインメントプログラム: MMseqs2
  - 検出感度を決めるパラメータ:  -s 8.5 (かなり強め)
- 評価値を計算
  - 予測されたorthologyの確からしさを評価: R_orthology > 1
  - NCBI orthologsおよびNCBI gene summaryと比較して裏付けを取った
- v1
  - 16,238 pairs of human and mouse protein coding genes
