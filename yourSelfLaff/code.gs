function makeForm() {
  const newForm = FormApp.create('お笑い芸人に関するアンケート');
  newForm.setDescription('このフォームでGASで作成しました。皆様のアンケートをもとにアプリケーションを作成いたします。');
  //入力先

  
  //出力先
  newForm.setDestination(FormApp.DestinationType.SPREADSHEET, '1vQ2VkF67g4l1RKBy4nSCpLi8pYS68J0thQS91NbWq4Y');

for(let i=0;i<5;i++){
  index = random(5-i)
  turget(newForm,index)
}
}

//ランダムな数字を作成
function random(max){
  return Math.floor(Math.random()*max);
}

//どの芸人について調べるかを求める
function turget(newForm,index){
  const item = newForm.addGridItem();
  //let geinin = objData.geinin[index];
  item.setTitle('上記のyoutubeを見て感じたことを答えてください。')
    .setRows(['面白い', 'つまらない', 'アップテンポ', 'スローテンポ','心温まる','刺激的','ホッコリする','ゾッとする','みんなで見たい','一人で見たい'])
    .setColumns([1,2,3,4,5]);
  //delete objData.geinin[index]
}