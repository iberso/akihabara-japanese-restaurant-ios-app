//
//  ViewController2.swift
//  UTS_c14190189
//
//  Created by Adakah? on 09/10/21.
//

import UIKit

protocol kembaliDelegate {
    func resetItemsQTY()
}

class ViewController2: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var labelSubtotal: UILabel!
    @IBOutlet weak var labelPajak: UILabel!
    @IBOutlet weak var labelTotalAll: UILabel!
    @IBOutlet weak var tableview2: UITableView!
    var itemsDariSatu = [Citems]()
    var itemPesan = [Citems]()
    var delegasi: kembaliDelegate?
    
    var subtotal = 0
    var pajak = 0
    var total = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview2.delegate = self
        tableview2.dataSource = self
        for i in 0..<itemsDariSatu.count {
            let jenis: String = itemsDariSatu[i].jenisItem
            var nama: [String] = []
            var harga: [Int] = []
            var qty: [Int] = []
            
            for j in 0..<itemsDariSatu[i].namaItem.count {

                if itemsDariSatu[i].qtyItem[j] != 0 {
                    nama.append(itemsDariSatu[i].namaItem[j])
                    harga.append(itemsDariSatu[i].hargaItem[j])
                    qty.append(itemsDariSatu[i].qtyItem[j])
                    subtotal += itemsDariSatu[i].hargaItem[j] * itemsDariSatu[i].qtyItem[j]
                    }
                }

            itemPesan.append(Citems.init(jenisItem: jenis, namaItem: nama , hargaItem: harga, qtyItem: qty))
        }
        
        labelSubtotal.text = "Rp. " + formatRupiah(uang: subtotal) + ",00"
        
        pajak = subtotal * 10 / 100
        labelPajak.text = "Rp. " + formatRupiah(uang: pajak) + ",00"
        
        total = subtotal + pajak
        labelTotalAll.text = "Rp. " + formatRupiah(uang: total) + ",00"
    }
    
    @IBAction func btnBayar(_ sender: Any) {
        alert(txt: "Pesanan Berhasil Dibayar",btnText: "Selesai")
        delegasi?.resetItemsQTY()
    }
    
    func alert(txt:String, btnText: String){
        let ac = UIAlertController(title: txt, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: btnText, style: .default, handler: {(_) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(ac,animated: true)
    }
    
    func checkSection(section: Int) -> Bool {
        var status = false
            for j in 0..<itemPesan[section].namaItem.count {
                if itemPesan[section].qtyItem[j] != 0 {
                    status = true
                }
            }
        return status
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemPesan.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableview2.dequeueReusableCell(withIdentifier: "cell2")! as! customTableVIewCell2
        let nmItem = itemPesan[indexPath.section].namaItem[indexPath.row]
        let hrgItem = itemPesan[indexPath.section].hargaItem[indexPath.row]
        let qty = itemPesan[indexPath.section].qtyItem[indexPath.row]
        let total = hrgItem * qty
        cell2.jumlah.text = String(qty)
        cell2.hitung.text = String(qty) + " x @" + formatRupiah(uang: hrgItem)
        cell2.namaItem.text = nmItem.capitalizingFirstLetter()
        cell2.total.text = " =  "	+ formatRupiah(uang: total)
        
        return cell2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemPesan[section].namaItem.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if checkSection(section: section) {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
            let label = UILabel()
    
            label.text = itemPesan[section].jenisItem
            label.frame = CGRect(x: 10, y: 15, width: view.frame.size.width, height: 30)
            label.textColor = UIColor.black
            label.textAlignment = NSTextAlignment.left
            label.font = UIFont.boldSystemFont(ofSize: 20)
            
            header.addSubview(label)
            return header
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if checkSection(section: section) {
            return 50
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if checkSection(section: indexPath.section) {
            return 69
        }else{
            return 0
        }
    }
    
    
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

}
