//
//  ViewController.swift
//  UTS_c14190189
//
//  Created by Adakah? on 07/10/21.
//

import UIKit

class Citems{
    var jenisItem: String
    var namaItem: [String]
    var hargaItem:[Int]
    var qtyItem:[Int]
    
    init(jenisItem:String,namaItem:[String],hargaItem:[Int],qtyItem:[Int]) {
        self.jenisItem = jenisItem
        self.namaItem = namaItem
        self.hargaItem = hargaItem
        self.qtyItem = qtyItem
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,kembaliDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    let toolBar = UIToolbar()
    let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))

    var items = [Citems]()

    
    @IBAction func btnPesan(_ sender: Any) {
        if checkAllQty() {
            performSegue(withIdentifier: "pindahHitung", sender: self)
        }else{
            alert(txt: "Pesanan tidak boleh kosong!")
            scrollToTop()
        }
    }
    
    func alert(txt:String){
        let ac = UIAlertController(title: txt, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in
        }))
        self.present(ac,animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items.append(Citems.init(jenisItem:"Makanan",namaItem:["ramen","sushi","okonomiyaki","yakitori","onigiri"],hargaItem: [25000,22000,30000,15000,10000],qtyItem: [0,0,0,0,0]))
        items.append(Citems.init(jenisItem:"Minuman",namaItem:["green-tea","kombucha","sake","ramune","water"],hargaItem: [10000,15000,35000,7000,5000],qtyItem: [0,0,0,0,0]))
              
        tableView.delegate = self
        tableView.dataSource = self
        
        toolBar.sizeToFit()
        toolBar.setItems([doneButton], animated: false)
       
    }
    
    @objc func doneClicked(){
        view.endEditing(true)
    }

    //buat cek Quantity per items
    func checkAllQty() -> Bool {
        var status = false
        
        for i in 0..<items.count{
            for j in 0..<items[i].namaItem.count {
                if items[i].qtyItem[j] != 0 {
                    status = true
                }
            }
        }
        return status
    }
    
    //buat reset Quantity per items
    func resetItemsQTY()  {
        for i in 0..<items.count{
            for j in 0..<items[i].namaItem.count {
                items[i].qtyItem[j] = 0
            }
        }
        scrollToTop()
    }
    
    //buat scroll ke top table
    private func scrollToTop() {
        let topRow = IndexPath(row: 0,section: 0)
        self.tableView.scrollToRow(at: topRow,at: .top,animated: true)
    }
    
    //untuk buat section
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    //buat print sesuai ukuran data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].namaItem.count
    }
    
    //buat detect txtfield yg berubah
    @objc func txtFieldDidChange(textField: UITextField){
        let txt = String(textField.accessibilityHint!)
        items[searchItemIndex(itemSrc: txt).section].qtyItem[searchItemIndex(itemSrc: txt).row] = Int(textField.text!) ?? 0
    }

    //buat cari index dari items
    func searchItemIndex(itemSrc: String) -> IndexPath{
        var indexPath = NSIndexPath(row: 0, section: 0)
        for i in 0..<items.count{
            for j in 0..<items[i].namaItem.count {
                if items[i].namaItem[j] == itemSrc {
                    indexPath = NSIndexPath(row: j, section: i)
                }
            }
        }
        return indexPath as IndexPath
    }
    
    //buat create tiap cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            as! customTableViewCell

        cell.labelFood?.text = items[indexPath.section].namaItem[indexPath.row].capitalizingFirstLetter()
        cell.imageFood?.image = UIImage(named: items[indexPath.section].namaItem[indexPath.row] )
        cell.labelHarga?.text = "Rp. " + formatRupiah(uang: items[indexPath.section].hargaItem[indexPath.row] )
        cell.qtyFood.addTarget(self,action: #selector(txtFieldDidChange(textField:)), for: .editingChanged)
        cell.qtyFood.accessibilityHint = items[indexPath.section].namaItem[indexPath.row]
        cell.qtyFood.text = nil
        
        if items[indexPath.section].qtyItem[indexPath.row] != 0 {
            cell.qtyFood?.text = String(items[indexPath.section].qtyItem[indexPath.row])
        }else{
            cell.qtyFood.placeholder = String(items[indexPath.section].qtyItem[indexPath.row])
        }
        
        cell.qtyFood.inputAccessoryView = toolBar
        
        return cell
    }

    
    //untuk atur ketinggian tiap cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    //buat create header tiap section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        
        let label = UILabel()
        label.text = items[section].jenisItem
        label.frame = CGRect(x: 10, y: 0, width: view.frame.size.width, height: 50)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        header.backgroundColor = UIColor(red: 252/255, green: 212/255, blue: 179/255, alpha: 1.0)
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc2 = segue.destination as? ViewController2
        vc2?.itemsDariSatu = items
        vc2?.delegasi = self
    }
    
    
    //ubah format currency ke IDR 
    func formatRupiah(uang: Int) -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        var txt = " "
        if let formattedTipAmount = formatter.string(from: uang as NSNumber) {
            txt = formattedTipAmount
        }
        return txt
    }

    
    //buat cek keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    //buat ngubah ukuran table view pas keyboard show jadi keyboard tidak menutupi table view
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
           
    }

    @objc func keyboardWillDisappear() {
        tableView.contentInset = .zero
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

